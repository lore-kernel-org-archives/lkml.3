Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3EQCxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:53:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34683 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab3EQCxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:53:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, vgoyal@redhat.com,
        akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6>
	<51957469.2000008@zytor.com>
Date: Thu, 16 May 2013 19:53:31 -0700
In-Reply-To: <51957469.2000008@zytor.com> (H. Peter Anvin's message of "Thu,
	16 May 2013 17:06:01 -0700")
Message-ID: <87y5bee2qc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19JEcUZxXkgpNmRlsrt7Ex6k3i5OKVgMzc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0037]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v6 0/8] kdump, vmcore: support mmap() on /proc/vmcore
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 05/15/2013 02:05 AM, HATAYAMA Daisuke wrote:
>> Currently, read to /proc/vmcore is done by read_oldmem() that uses
>> ioremap/iounmap per a single page. For example, if memory is 1GB,
>> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
>> times. This causes big performance degradation.
>
> read_oldmem() is fundamentally broken and unsafe.  It needs to be
> unified with the plain /dev/mem code and any missing functionality fixed
> instead of "let's just do a whole new driver".

That is completely and totally orthogonal to this change.

read_oldmem may have problems but in practice on a large systems those
problems are totally dwarfed by real life performance issues that come
from playing too much with the page tables.

I really don't find bringing up whatever foundational issues you have
with read_oldmem() appropriate or relevant here.

Eric
