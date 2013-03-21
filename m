Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3CUGQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:16:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33210 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3CUGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:16:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
	<20130321.125245.142520187.d.hatayama@jp.fujitsu.com>
Date: Wed, 20 Mar 2013 23:16:20 -0700
In-Reply-To: <20130321.125245.142520187.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 12:52:45 +0900 (JST)")
Message-ID: <87d2ut2s7f.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18qtkszsrzfshaT3HXOOcLDtQnUPL9rsRw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
> Date: Tue, 19 Mar 2013 12:30:05 -0700
>
>> On Sat, 16 Mar 2013 13:00:47 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>> 
>>> Currently, read to /proc/vmcore is done by read_oldmem() that uses
>>> ioremap/iounmap per a single page. For example, if memory is 1GB,
>>> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
>>> times. This causes big performance degradation.
>>> 
>>> In particular, the current main user of this mmap() is makedumpfile,
>>> which not only reads memory from /proc/vmcore but also does other
>>> processing like filtering, compression and IO work. Update of page
>>> table and the following TLB flush makes such processing much slow;
>>> though I have yet to make patch for makedumpfile and yet to confirm
>>> how it's improved.
>>> 
>>> To address the issue, this patch implements mmap() on /proc/vmcore to
>>> improve read performance. My simple benchmark shows the improvement
>>> from 200 [MiB/sec] to over 50.0 [GiB/sec].
>> 
>> There are quite a lot of userspace-visible vmcore changes here.  Is it
>> all fully back-compatible?  Will all known userspace continue to work
>> OK on newer kernels?
>> 
>
> I designed it to keep backward-compatibility at least for gdb and
> binutils but not less for makedumpfile since it should follow kernel
> changes; old makedumpfile cannot use newer kernels, and this is within
> the range of this review.

To the extent possible we should different versions of tools to be
interchanged.  That helps with bug hunting and for people who are in
resource constrained systems that build old versions of the tools that
are tiny and fit.

Given that rounding the per cpu NOTES turns out to be a waste of memory
I didn't see anything in the patchset that justfies any breakage.

Eric

