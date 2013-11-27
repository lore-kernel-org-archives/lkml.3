Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3K0UlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:41:12 -0500
Received: from mout.web.de ([212.227.17.11]:57568 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab3K0UlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:41:08 -0500
Message-ID: <4EE8EA759E2646FFB2FC72F10ED743AC@samsungnetbook>
From: "Roland" <devzero@web.de>
To: "H. Peter Anvin" <hpa@zytor.com>, <kernel-team@lists.ubuntu.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <trinity-1045dd8c-e43f-4f8c-94e4-c0f0f15f611d-1385507362267@3capp-webde-bs36> <52952FD9.1060906@zytor.com>
In-Reply-To: <52952FD9.1060906@zytor.com>
Subject: Re: [PATCH] - add "fixpae" bootparam to fix/workaround #930447
Date: Wed, 27 Nov 2013 21:41:03 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8064.206
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8064.206
X-Antivirus: avast! (VPS 131127-1, 27.11.2013), Outbound message
X-Antivirus-Status: Clean
X-Provags-ID: V03:K0:JwTUBSizEr8co5FciQNPxWuUUtpXtlN1CGMxeeHSh9mQC3aUKD9
 LnwH8CgpXEEPFbWHHjpF02G+tQZWi5DaBAqRpifV+4RwNMOnIHKnCpem0eRDWEZoKrg7dCr
 /KUthcEc2zvlBgzY0TZ9ZKfzMfSOXrZVB45LyEloJwYsItmQONRu8+OIjCO/Yq+s5VKivcs
 Hm28geBNIzB8OOKcMFoKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is meant primarly for ubuntu, as they only ship PAE enabled 
kernels and don`t ship non-PAE kernels anymore.  So this resolves an ubuntu 
specific problem (as the installer disc also has PAE enabled kernel).

I know it`s not perfect, but poking cpu bits in arrays is above my skills 
and i have already spent really much time with this trying to resolve a 
problem for the end-user intruduced by nothing but the decision to 
discontinue Non-PAE kernels.

If grub2 can do nasty or ugly things like skipping standard x86 bootcode 
(which also skips validate_cpu() - while nobody seems to have a problem with 
that) , then i don`t understand what´s the real problem to add a very simple 
and unintrusive quirk to a vendor specific kernel.

Let time go by and the quirk will be obsolete one day anyway as no hardware 
lives forever.

But for now there exist distros like lubuntu meant for older hardware, and 
if installing that on a Pentium M 1,7 Ghz fails because of that nasty PAE 
issue nobody is willing to fix elegantly, then i think it deserves only one 
term:

planned obsolescence

I`s bad enough, that industry does produce products with limited lifetime. 
Products that break and that even can`t be repaired.

So please, kernel people, don`t think that way. Care for the users.

Many thinkpad users will be thankful if they can install their favourite 
distro by just adding a bootparam instead of reading through tons of pages 
how to add even weirder workarounds like bind-mounting a modified copy of 
itself on top of /proc/cpuinfo.

regards
Roland

ps:
https://help.ubuntu.com/community/Lubuntu-fake-PAE

--------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Sent: Wednesday, November 27, 2013 12:33 AM
To: "Roland Kletzing" <devzero@web.de>; <kernel-team@lists.ubuntu.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] - add "fixpae" bootparam to fix/workaround #930447

> On 11/26/2013 03:09 PM, Roland Kletzing wrote:
>> Hello kernel-team,
>>
>> regarding https://bugs.launchpad.net/ubuntu/+source/syslinux/+bug/930447 
>> , i have developed a simple patch to (hopefully) provide an easy and 
>> elegant workaround/fix for the issue. I assume some hundred users (if not 
>> some thousand, as entries in bugreports are only the tip of an iceberg) 
>> are affected by this issue.
>>
>> Please take a review and feel free to merge.
>>
>> As defaulting to PAE kernels is specific for some distros only, i think 
>> this is no patch for mainline (yet).
>>
>> I did not often do patches, nor am i a good programmer - so sorry if the 
>> patch or the submission style is not perfect.
>>
>> regards
>> Roland
>
> No, this is not an acceptable patch per se.
>
> The right way to do this is to have the option, if it is found, simply
> set the bit in the CPU array.  However, it is important to verify that
> we are on the affected type of CPU, specifically the affected Pentium Ms.
>
> x86 patches should be sent to <x86@kernel.org> or equivalently myself,
> <mingo@kernel.org> and <tglx@linutronix.de> and Cc:
> <linux-kernel@vger.kernel.org>.  I also encourage you to read the file
> Documentation/SubmittingPatches before trying again.
>
> -hpa
> 
