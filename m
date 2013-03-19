Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934398Ab3CSXfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:35:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41373 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800Ab3CSXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:35:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040132.15064.42257.stgit@localhost6.localdomain6>
	<878v5jqf5e.fsf@xmission.com> <20130319212244.GE3872@redhat.com>
Date: Tue, 19 Mar 2013 16:35:36 -0700
In-Reply-To: <20130319212244.GE3872@redhat.com> (Vivek Goyal's message of
	"Tue, 19 Mar 2013 17:22:44 -0400")
Message-ID: <87boafhsjb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX194T1mKv73HbTMzaNzxybOAclYT3ReQWSk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 08/21] vmcore: copy non page-size aligned head and tail pages in 2nd kernel
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Are you saying that some parts of the vmcore file will support mmap() and
> others will not. If yes, how would a user know which parts of file are
> mappable and which are not.

I think I answered this in another email in my review but I will
reanswer here.

There is absolutely no need to copy pages.  We can round up the mapping
to the nearest full page.  Mmap already does that today for files so it
isn't even odd.

Which only leaves the headers and notes as potentially unmmapable.  That
is more of a policy decision, and a decision on where we want to spend
memory.  Rounding ELF notes to mutliples of PAGE_SIZE from a perspective
of memory usage seems pretty terrible taking memory usage up an order of
magnitude.

Eric
