Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162707Ab3DEUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:05:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39209 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162687Ab3DEUF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:05:59 -0400
Message-ID: <515F2E81.9000900@zytor.com>
Date: Fri, 05 Apr 2013 13:05:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DE0C9.3030709@zytor.com> <CAE9FiQVCC2-yF0+bt2MryHDs2vK8bcsU1aE-is_ejDDF0dTbMQ@mail.gmail.com>
In-Reply-To: <CAE9FiQVCC2-yF0+bt2MryHDs2vK8bcsU1aE-is_ejDDF0dTbMQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 01:01 PM, Yinghai Lu wrote:
> On Thu, Apr 4, 2013 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I have to admit to being somewhat skeptical toward KASLR with only 8
>> bits of randomness.  There are at least two potential ways of
>> dramatically increasing the available randomness:
>>
>> 1. actually compose the kernel of multiple independently relocatable
>>    pieces (maybe chunk it on 2M boundaries or something.)
>>
>> 2. compile the kernel as one of the memory models which can be executed
>>    anywhere in the 64-bit address space.  The cost of this would have
>>    to be quantified, of course.
> 
> Why just let bootloader to load kernel on random address instead?
> 
> For our 64bit bzImage, boot loader could load kernel to anywhere above 4G.
> 

That makes zero difference, since the issue at hand is the *virtual*
addresses the kernel are running at.  Currently, the 64-bit kernel
always runs at 0xffffffff81000000 virtual.  We can't run out of
arbitrary bits of the 64-bit address space because of the memory model.

Furthermore, dealing with the boot loaders means dealing with the boot
loader maintainers, which can be insanely painful.  Consider that Grub2,
10 years after this was implemented, still can't load more than one
initramfs component.

	-hpa


