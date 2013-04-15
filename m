Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3DOVGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 17:06:38 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:37330 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3DOVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 17:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <516A1D49.1050100@zytor.com>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
	<CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
	<516A1D49.1050100@zytor.com>
Date: Mon, 15 Apr 2013 14:06:33 -0700
Message-ID: <CAG7+5M12cAavi9XBYoe39X=JtpWUu4wxjaAfOZP+=1qaKz7C+A@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
From: Eric Northup <digitaleric@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 8:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/13/2013 05:37 PM, Yinghai Lu wrote:
>>
>> so decompress code position is changed?
>>
>> You may push out bss and other data area of run-time kernel of limit
>> that boot loader
>> chose according to setup_header.init_size.
>> aka that make those area overlap with ram hole or other area like
>> boot command line or initrd....
>>
>
> Is there a strong reason to randomize the physical address on 64 bits
> (and if so, shouldn't we do it right?)

The reason to randomize the physical address is because of the kernel
direct mapping range -- a predictable-to-attackers physical address
implies a predictable-to-attackers virtual address.

It had seemed to me like changing the virtual base of the direct
mapping would be much more involved than physically relocating the
kernel, but better suggestions would be most welcome :-)
