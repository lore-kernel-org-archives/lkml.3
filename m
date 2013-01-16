Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab3APEa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:30:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34027 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab3APEa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:30:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
Date: Tue, 15 Jan 2013 20:30:41 -0800
In-Reply-To: <1358285695-26173-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 15 Jan 2013 16:34:54 -0500")
Message-ID: <871udloiku.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18mYgyzw76ktvjTmy6yOZ065SfwQPSATPM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> If a binary is signed, verify its signature. If signature is not valid, do
> not allow execution. If binary is not signed, execution is allowed
> unconditionally.
>
> CONFIG_BINFMT_ELF_SIGNATURE controls whether elf binary signature support
> is compiled in or not.
>
> Signature are expected to be present in elf section ".section". This code
> is written along the lines of module signature verification code. Just
> that I have removed the magic string. It is not needed as signature is
> expected to be present in a specific section.
>
> I put the signature into a section, instead of appending it so that
> strip operation works fine.
>
> One signs and verifies  all the areas mapped by PT_LOAD segments of elf
> binary. Typically Elf header is mapped in first PT_LOAD segment. As adding
> .signature section can change three elf header fields (e_shoff, e_shnum
> and e_shstrndx), these fields are excluded from digest calculation

My gut feel says that a signature that we verify should reside in an ELF
segment.  Sections are for the linker not the kernel.

I don't totally know what the signature should cover but my gut feels
says the signature should come after ever non-signature segment and
cover all of the prior segments (PT_LOAD or not).  Because presumably
the loader needs to look at everything in a segment.  We can
restrict ourselves to only processing signed binaries on executables
with only PT_LOAD segments and signatures for now.

Eric
