Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3EQE3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:29:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:55917 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3EQE3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:29:17 -0400
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
	<51957469.2000008@zytor.com> <87y5bee2qc.fsf@xmission.com>
	<5195A223.2070204@zytor.com>
Date: Thu, 16 May 2013 21:29:03 -0700
In-Reply-To: <5195A223.2070204@zytor.com> (H. Peter Anvin's message of "Thu,
	16 May 2013 20:21:07 -0700")
Message-ID: <87vc6icjqo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18YgJjwe3AAUXqzdlKf1LwpKvUMy3Ejmwk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0157]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v6 0/8] kdump, vmcore: support mmap() on /proc/vmcore
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 05/16/2013 07:53 PM, Eric W. Biederman wrote:
>> 
>> That is completely and totally orthogonal to this change.
>> 
>> read_oldmem may have problems but in practice on a large systems those
>> problems are totally dwarfed by real life performance issues that come
>> from playing too much with the page tables.
>> 
>> I really don't find bringing up whatever foundational issues you have
>> with read_oldmem() appropriate or relevant here.
>> 
>
> Well, it is in the sense that we have two pieces of code doing the same
> thing, each with different bugs.

Not a the tiniest little bit.

All this patchset is about is which page table kernel vs user we map the
physical addresses in.

As such this patchset should neither increase nor decrease the number of
bugs, or cause any other hilarity.

Whatever theoretical issues you have with /dev/oldmem and /proc/vmcore
can and should be talked about and addressed independently of these
changes.  HATMAYA Daisuke already has enough to handle coming up with a
clean set of patches that add mmap support.

Eric
