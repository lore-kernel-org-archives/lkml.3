Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3EYUgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 16:36:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34297 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab3EYUgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 16:36:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130524143644.GD18218@redhat.com> <20130524170626.2ac06efe@holzheu>
	<20130524152849.GF18218@redhat.com> <87mwrkatgu.fsf@xmission.com>
	<51A006CF.90105@gmail.com> <87k3mnahkf.fsf@xmission.com>
	<51A076FE.3060604@gmail.com>
Date: Sat, 25 May 2013 13:36:09 -0700
In-Reply-To: <51A076FE.3060604@gmail.com> (Zhang Yanfei's message of "Sat, 25
	May 2013 16:31:58 +0800")
Message-ID: <8761y6ajba.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19MWJ7MIN2aOHBpWntggRtT91YD7Nbk/Ss=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei.yes@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:

> 于 2013年05月25日 11:01, Eric W. Biederman 写道:
>> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
>> 
>>> Hello Eric,
>>>
>>>> The function copy_oldmem_page also concerns me.  I don't have a clue why
>>>> we duplicate that function on every architecutre in a slightly different
>>>> form.  There should be enough abstractions in the kernel to make that
>>>> unnecessary.  I would be glad to see that function go, and remove the
>>>> possibility of confusion that happened on s390.
>>>
>>> You mean we should have a common copy_oldmem_page for all architectures? And
>>> just like vivek said above, for s390, we should put the swap info in the elf
>>> headers instead of doing that in copy_oldmem_page.
>> 
>> Exactly.
>> 
>> The user space change in /sbin/kexec should even be backwards compatible
>> for s390.  So fixing /sbin/kexec should probably come first.
>> 
>
> I am kind of not sure about the "backwards compatible for s390" you meant.
>
> For s390, if we put swap info into the elf header, This will change /sbin/kexec.
> But at this point, copy_oldmem_page is still doing the swap when we try to read
> the pages among [0 - OLDMEM_SIZE] and [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE].
> So removing the swap in copy_oldmem_page should be done at the same time.
> New kexec with old kernels would fail and old kexec with new kernels would fail too.
>
> So could you please explain more about the ""backwards compatible". And please
> correct me if I am wrong.

It looks like my misreading of things.  I was not expecting the existing
copy_oldmem_page to do a complete swap of addresses.  I was expecting
something like the result obtained by doing a header swap with the ELF
headers where part of the address was translated and the rest was simply
not mentioned.

But from other replies it appears there isn't a problem.

Eric

