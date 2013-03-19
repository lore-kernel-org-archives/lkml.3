Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3CSWiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:38:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47100 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab3CSWiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:38:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040228.15064.28019.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 15:38:45 -0700
In-Reply-To: <20130316040228.15064.28019.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:02:29 +0900")
Message-ID: <877gl3koay.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+BUDxuLUuV2ATjnbIUnIv+5+fDDO0Am2M=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> If there's some vmcore object that doesn't satisfy page-size boundary
> requirement, remap_pfn_range() fails to remap it to user-space.
>
> Objects that posisbly don't satisfy the requirement are ELF note
> segments only. The memory chunks corresponding to PT_LOAD entries are
> guaranteed to satisfy page-size boundary requirement by the copy from
> old memory to buffer in 2nd kernel done in later patch.
>
> This patch doesn't copy each note segment into the 2nd kernel since
> they amount to so large in total if there are multiple CPUs. For
> example, current maximum number of CPUs in x86_64 is 5120, where note
> segments exceed 1MB with NT_PRSTATUS only.

So you require the first kernel to reserve an additional 20MB, instead
of just 1.6MB.  336 bytes versus 4096 bytes.

That seems like completely the wrong tradeoff in memory consumption,
filesize, and backwards compatibility.

Eric
