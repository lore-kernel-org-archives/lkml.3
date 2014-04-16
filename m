Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaDPVRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:17:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46377 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596AbaDPVRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:17:38 -0400
Message-ID: <534EF354.3090204@zytor.com>
Date: Wed, 16 Apr 2014 14:17:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix page-tables reserved bits
References: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il> <20140416190329.GB8773@amt.cnet>
In-Reply-To: <20140416190329.GB8773@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 12:03 PM, Marcelo Tosatti wrote:
>> @@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
>>  		break;
>>  	case PT64_ROOT_LEVEL:
>>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
>> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
>>  		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
>> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
>> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
> 
> Bit 7 is not reserved either, for the PDPTE (its PageSize bit).
> 

In long mode (IA-32e), bit 7 is definitely reserved.

	-hpa

