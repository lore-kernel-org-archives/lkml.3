Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3EYDCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 23:02:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37125 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3EYDB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 23:01:58 -0400
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
	<51A006CF.90105@gmail.com>
Date: Fri, 24 May 2013 20:01:36 -0700
In-Reply-To: <51A006CF.90105@gmail.com> (Zhang Yanfei's message of "Sat, 25
	May 2013 08:33:19 +0800")
Message-ID: <87k3mnahkf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/iElZGxUirebqAmxzUJFo2i/3l7RyWro8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
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

> Hello Eric,
>
>> The function copy_oldmem_page also concerns me.  I don't have a clue why
>> we duplicate that function on every architecutre in a slightly different
>> form.  There should be enough abstractions in the kernel to make that
>> unnecessary.  I would be glad to see that function go, and remove the
>> possibility of confusion that happened on s390.
>
> You mean we should have a common copy_oldmem_page for all architectures? And
> just like vivek said above, for s390, we should put the swap info in the elf
> headers instead of doing that in copy_oldmem_page.

Exactly.

The user space change in /sbin/kexec should even be backwards compatible
for s390.  So fixing /sbin/kexec should probably come first.

Eric
