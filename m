Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab3BMIG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:06:29 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49433 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab3BMIG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:06:27 -0500
MIME-Version: 1.0
In-Reply-To: <511ADC79.6040007@zytor.com>
References: <1359495169-23278-1-git-send-email-ostr@amd64.org>
	<tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
	<20130213001626.GA30512@pd.tnic>
	<511ADC79.6040007@zytor.com>
Date: Wed, 13 Feb 2013 10:06:25 +0200
X-Google-Sender-Auth: utC8eqnueg9X5bVfJ1nqVJQbITo
Message-ID: <CAOJsxLH71KTFbkm5h9AuquC04cJ0NmtCiUjSevkxqLYRBPPi8g@mail.gmail.com>
Subject: Re: [tip:x86/cpu] x86, AMD: Enable WC+ memory type on family 10 processors
From: Pekka Enberg <penberg@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Sasha Levin <sasha.levin@oracle.com>, Asias He <asias@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 2:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> +                       rdmsrl(MSR_AMD64_BU_CFG2, value);
>>> +                       value &= ~(1ULL << 24);
>>> +                       wrmsrl(MSR_AMD64_BU_CFG2, value);
>>> +               }
>>>         }
>>>
>>>         rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
>>
>>
>> However, the more serious issue is that that same kernel #GPs when
>> booted in kvm. It seems it cannot stomach that specific MSR, see the
>> second "<-- trapping instruction" below and that BU_CFG2 MSR landing in
>> %ecx in the line before that.
>>
>> Oh, and this happens only with the kvm executable (/usr/bin/kvm) in
>> debian testing. If I use qemu from git, it passes over init_amd just
>> fine.
>>
>> Hmmm..
>
> It #GPs on an MSR, which tends to be a bug in the VMM; RDMSR/WRMSR generally
> kick out to the VMM.  There isn't a huge lot of work we can do about that...
>
> I think Qemu defaults to ignoring unknown-to-it MSRs whereas maybe kvmtool
> croaks?  Pekka?

I think we should also be fine. Cyrillos?
