Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3CLTsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:48:25 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58308 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab3CLTsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:48:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, hpa@zytor.com, yinghai@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
	<20130307152108.GC2790@redhat.com> <87k3piri3e.fsf@xmission.com>
	<20130308155216.GB8219@redhat.com> <513D9338.20402@hp.com>
	<87wqtenug7.fsf@xmission.com> <513EFDD6.806@hp.com>
Date: Tue, 12 Mar 2013 12:48:07 -0700
In-Reply-To: <513EFDD6.806@hp.com> (Jingbai Ma's message of "Tue, 12 Mar 2013
	18:05:10 +0800")
Message-ID: <87sj408knc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19eal6wtbdjWcDV/auh7U+i9yi0Eu3zTDw=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jingbai Ma <jingbai.ma@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingbai Ma <jingbai.ma@hp.com> writes:

> On 03/11/2013 05:42 PM, Eric W. Biederman wrote:

>> The kernel is known bad.  What is bad is unclear.
>> Executing any extra code is a bad idea.
>>
>> The history here is that before kexec-on-panic there were lots of dump
>> routines that did all of the crashdump logic in the kernel before they
>> shutdown.  They all worked beautifully during development, and on
>> developers test machines and were absolutely worthless in real world
>> situations.
>
> I also have learned some from the old style kernel dump. Yes, they do have some
> problems in real world situations. The primary problems come from I/O operations
> (disk writing/network sending) and invalid page table.

That and they provide no guarantee that you won't write corrupt data.

The kdump based solutions fail safe.  The worst that will happen is that
you don't take a crash dump.  There is no chance of corrupting your
system.


>> A piece of code that walks all of the page tables is most definitely
>> opening itself up to all kinds of failure situations I can't even
>> imagine.
>
> Agree, invalid page table will cause disaster.
> But even in the capture kernel with user space program, it may only causes a
> core dump, user still have chance to dump the crashed system by themselves with
> some special tools, It's possible, but should be very rare in real world.
> I doubt how many users be able to handle it in such kind of situations.
> So in most cases, if page tables have corrupted, and can not dump it normally,
> user would like to reboot the system directly.

For whatever it is worth corrupted page tables.  Or at least page tables
that the cpu thinks are invalid are one of the crash scenarios that I
have seen in the wild on enough occasions to remember them.

Eric

