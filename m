Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaGJA4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:56:40 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56159 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaGJA4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:56:38 -0400
Message-ID: <53BDE4BD.50605@gmail.com>
Date: Wed, 09 Jul 2014 19:56:29 -0500
From: Stuart Hayes <stuart.w.hayes@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com, bp@suse.de
Subject: Re: [PATCH] x86: Configure NX support earlier in setup_arch
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com> <53BC72D8.4090705@zytor.com>
In-Reply-To: <53BC72D8.4090705@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/8/2014 5:38 PM, H. Peter Anvin wrote:

> On 07/08/2014 03:34 PM, Stuart Hayes wrote:
>>
>> I haven't received any responses... is there a problem with the patch?  Also CCing a couple people.
>>
> 
> I was on vacation last week and am still catching up.
> 
> It would also help if you describe the real-world scenario that made you
> trip over this.
> 
> 	-hpa
> 


Well... I got this issue because a co-worker tripped over it.  He had NX disabled in BIOS for some reason, and found that linux wouldn't boot--it hung right after grub2.  I guess it took a while to figure out that it was the fact that NX was disabled that caused linux not to come up--and that could happen to other people.  I don't know of any real-world scenarios in which someone would actually prefer to run a recent linux kernel with NX disabled, though.

It looks like some of the other boot paths into the kernel automatically clear the XD_DISABLE bit in the MISC_ENABLE MSR in the CPU (in verify_cpu), but that doesn't happen when grub2 jumps to startup_64 in arch/x86/boot/compressed/head_64.S.  I guess instead of this patch, I could try to make a patch that turns NX back on (somewhere in startup_64), but since the kernel already supports NX being disabled, so I thought maybe just fixing that would be better.  I didn't like seeing the kernel just die without giving any indication of what the problem is.

Stuart

