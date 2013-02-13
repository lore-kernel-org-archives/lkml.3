Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3BMAWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:22:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58677 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759077Ab3BMAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:22:37 -0500
Message-ID: <511ADC79.6040007@zytor.com>
Date: Tue, 12 Feb 2013 16:21:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@amd.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
CC: Pekka Enberg <penberg@kernel.org>
Subject: Re: [tip:x86/cpu] x86, AMD: Enable WC+ memory type on family 10 processors
References: <1359495169-23278-1-git-send-email-ostr@amd64.org> <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org> <20130213001626.GA30512@pd.tnic>
In-Reply-To: <20130213001626.GA30512@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 04:16 PM, Borislav Petkov wrote:
>
> This family check is redundant, we're already in a 0x10 if-branch
> above. Boris had sent a second version which doesn't have that check:
> http://marc.info/?l=linux-kernel&m=135949774114910 but I don't know how this
> other version has gotten in.
>
> @hpa: maybe replace - patch is still at the top of tip:x86/cpu?
>

I'll check with Ingo if that is doable.

>> +			rdmsrl(MSR_AMD64_BU_CFG2, value);
>> +			value &= ~(1ULL << 24);
>> +			wrmsrl(MSR_AMD64_BU_CFG2, value);
>> +		}
>>   	}
>>
>>   	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
>
> However, the more serious issue is that that same kernel #GPs when
> booted in kvm. It seems it cannot stomach that specific MSR, see the
> second "<-- trapping instruction" below and that BU_CFG2 MSR landing in
> %ecx in the line before that.
>
> Oh, and this happens only with the kvm executable (/usr/bin/kvm) in
> debian testing. If I use qemu from git, it passes over init_amd just
> fine.
>
> Hmmm..
>

It #GPs on an MSR, which tends to be a bug in the VMM; RDMSR/WRMSR 
generally kick out to the VMM.  There isn't a huge lot of work we can do 
about that...

I think Qemu defaults to ignoring unknown-to-it MSRs whereas maybe 
kvmtool croaks?  Pekka?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

