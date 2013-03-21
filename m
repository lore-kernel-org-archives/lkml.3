Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab3CUHXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:23:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51358 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab3CUHXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:23:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <87txo5bxk4.fsf@xmission.com>
	<20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
	<8738vp75cy.fsf@xmission.com>
	<20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 00:22:59 -0700
In-Reply-To: <20130321.151428.393714972.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 15:14:28 +0900 (JST)")
Message-ID: <87y5dhw71o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+CegGRvZ1IcDtKGvxq+Ats6It0oOoPgMI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
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

> OK, rigorously, suceess or faliure of the requested free pages
> allocation depends on actual memory layout at the 2nd kernel boot. To
> increase the possibility of allocating memory, we have no method but
> reserve more memory for the 2nd kernel now.

Good enough.   If there are fragmentation issues that cause allocation
problems on larger boxes we can use vmalloc and remap_vmalloc_range, but
we certainly don't need to start there.

Especialy as for most 8 or 16 core boxes we are talking about a 4KiB or
an 8KiBP allocation.  Aka order 0 or order 1.

Adding more memory is also useful.  It is important in general to keep
the amount of memory needed for the kdump kernel low.

Eric

