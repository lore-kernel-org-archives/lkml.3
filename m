Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3CUGMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:12:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59944 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3CUGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:12:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040053.15064.93652.stgit@localhost6.localdomain6>
	<87ppyvnjyn.fsf@xmission.com>
	<20130321.115041.225288996.d.hatayama@jp.fujitsu.com>
Date: Wed, 20 Mar 2013 23:11:48 -0700
In-Reply-To: <20130321.115041.225288996.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 11:50:41 +0900 (JST)")
Message-ID: <87r4j92sez.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/7+OxeS7v7JctARKNtntDEoQMrLEn2V0I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 01/21] vmcore: reference e_phoff member explicitly to get position of program header table
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Subject: Re: [PATCH v3 01/21] vmcore: reference e_phoff member explicitly to get position of program header table
> Date: Tue, 19 Mar 2013 14:44:16 -0700
>
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>> 
>>> Currently, the code assumes that position of program header table is
>>> next to ELF header. But future change can break the assumption on
>>> kexec-tools and the 1st kernel. To avoid worst case, reference e_phoff
>>> member explicitly to get position of program header table in
>>> file-offset.
>> 
>> In principle this looks good.  However when I read this it looks like
>> you are going a little too far.
>> 
>> You are changing not only the reading of the supplied headers, but
>> you are changing the generation of the new new headers that describe
>> the data provided by /proc/vmcore.
>> 
>> I get lost in following this after you mangle merge_note_headers.
>> 
>> In principle removing silly assumptions seems reasonable, but I think
>> it is completely orthogonal to the task of maping vmcore mmapable.
>> 
>> I think it is fine to claim that the assumptions made here in vmcore are
>> part of the kexec on panic ABI at this point, which would generally make
>> this change unnecessary.
>
> This was suggested by Vivek. He prefers generic one.
>
> Vivek, do you agree to this? Or is it better to re-post this and other
> clean-up patches as another one separately to this patch set?

My deep problem with this patch was that you were changing how we think
about the generated headers, and that just didn't seem to make any
sense, and certainly it seems to be orthogonal from the patch itself.

For headers that we generate it is perfectly fine to make all kinds of
assumptions.

Eric

