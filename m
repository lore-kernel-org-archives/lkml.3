Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab3CUHO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:14:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55534 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab3CUHOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:14:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
	<20130321.125245.142520187.d.hatayama@jp.fujitsu.com>
	<87d2ut2s7f.fsf@xmission.com>
	<20130321.153537.03532110.d.hatayama@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 00:14:43 -0700
In-Reply-To: <20130321.153537.03532110.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 15:35:37 +0900 (JST)")
Message-ID: <87d2utxlzw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/4d8QBtpmmVdjw1dru6WDjKgshHV7p84s=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
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

> The breakage was caused by the introduction of new NT_VMCORE_PAD to
> "VMCOREINFO" name, except for which it worked fine. But it will be
> dropped in the next version. It'll be no problem for some time.
>
> The breakage was caused by makedumpfile itself due to the bug that it
> had so far seen note type only, not note name. It was possible to
> avoid the breakage by choosing another note name but I didn't do
> it. This topic will probably arise when some kind of new note types
> are needed.

Yes.  Not ignoring unknown note types is a a deficiency in makedumpfile.
And definitely not something to keep us from introducing new note types.

It should be noted that a common use of /proc/vmcore is to do:
cp /proc/vmcore /somepath/core

gdb /somepath/core

makedumpfile is just an optimization on that for people who want to
write a smaller file.

Eric
