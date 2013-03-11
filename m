Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3CKTOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:14:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38591 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3CKTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:14:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
References: <513D52BA.3070206@redhat.com>
	<1362977817-23297-1-git-send-email-yinghai@kernel.org>
	<20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com>
	<CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
	<20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
Date: Mon, 11 Mar 2013 12:14:16 -0700
In-Reply-To: <513E28B8.3000502@zytor.com> (H. Peter Anvin's message of "Mon,
	11 Mar 2013 11:55:52 -0700")
Message-ID: <87r4jllpfb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/kyX8mWbgtHXCBYq+w/JOIkH/IzSvMReg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/11/2013 11:50 AM, Yinghai Lu wrote:
>>>
>>> What is the purpose of reserving that kind of memory below 896 MB?  If
>>> you have a 32-bit system, it will likely be useless since you are
>>> robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
>>> a magic value in any way...?
>> 
>> We did not touch 32 bit system.
>> 
>> Do you mean that we should
>> For 64bit, we should try under 4G, and then try MAXMEM
>> instead of try under 896M, then 4G, and MAXMEM?
>> 
>> Try 896M at first, we will let user to avoid updating their kexec-tools.
>> 
>
> Are you saying 896M is somehow hardcoded into kexec-tools?
>
> I actually disagree with trying low memory at all.  Push kdump as high
> into the memory range as we can go, if there is a performance penalty it
> is much better to take it in the kdump kernel.
>
> All the voodoo to try to keep people from updating kexec-tools is
> disturbing; although breaking userspace is bad, updating kexec-tools is
> probably easier than updating the kernel, and carrying the voodoo on
> indefinitely has serious consequences.

I don't totally follow the reasoning, but there is one real motivating
example that is not easy to fix and it has little to do with
kexec-tools.  There is a practical issue that so far the easiest way
to deal with iommus after a kexec on panic is to just not use them.
The problem is what to do with existing DMAs transfers that were setup
by the kernel that crashed and are using the iommu.

When you are loaded above 4G not using iommus can be a challenge.

There are practical consequences to all of this that started this
discussion, and the practical consequences are primarily in kernel
behavior.


Eric
