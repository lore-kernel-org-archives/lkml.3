Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3APHKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:10:47 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41840 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3APHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:10:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	<871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
Date: Tue, 15 Jan 2013 23:10:27 -0800
In-Reply-To: <1358312159.4593.37.camel@falcor1> (Mimi Zohar's message of "Tue,
	15 Jan 2013 23:55:59 -0500")
Message-ID: <87wqvdli1o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19zXyOHlDKcf1LUay5xwTyvmFE6UMtEZn4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1232]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mimi Zohar <zohar@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> Please remind me why you can't use IMA-appraisal, which was upstreamed
> in Linux 3.7?  Why another method is needed?

Good question Vivek?  

I remeber there was a slight mismatch in the desired attributes.  In
particular we want signatures that are not generated on the local
machine.

> With IMA-appraisal, there are a couple of issues that would still need
> to be addressed:
> - missing the ability to specify the validation method required.
> - modify the ima_appraise_tcb policy policy to require elf executables
> to be digitally signed.
> - security_bprm_check() is called before the binary handler is known.
>
> The first issue is addressed by a set of patches queued to be upstreamed
> in linux-integrity/next-ima-appraise-status.
>
> To address the last issue would either require moving the existing
> bprm_check or defining a new hook after the binary handler is known.

Even if there is a small mismatch it certainly sounds like something to
investigate.  There are a lot of pieces flying around with IMA so an
appropriate model of what needs to happen isn't in my head.  As opposed
to a signature in an ELF executable and a key in the kernel.

Hooks aside in an IMA world where does the signing key live?  Where does
the signature live?

Eric

