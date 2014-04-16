Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406AbaDPWEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbaDPWEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:04:40 -0400
Date: Wed, 16 Apr 2014 19:04:09 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix page-tables reserved bits
Message-ID: <20140416220409.GB15155@amt.cnet>
References: <1396582264-9864-1-git-send-email-namit@cs.technion.ac.il>
 <20140416190329.GB8773@amt.cnet>
 <534EF354.3090204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534EF354.3090204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 02:17:08PM -0700, H. Peter Anvin wrote:
> On 04/16/2014 12:03 PM, Marcelo Tosatti wrote:
> >> @@ -3550,9 +3550,9 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
> >>  		break;
> >>  	case PT64_ROOT_LEVEL:
> >>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
> >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
> >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
> >>  		context->rsvd_bits_mask[0][2] = exb_bit_rsvd |
> >> -			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 8);
> >> +			rsvd_bits(maxphyaddr, 51) | rsvd_bits(7, 7);
> > 
> > Bit 7 is not reserved either, for the PDPTE (its PageSize bit).
> > 
> 
> In long mode (IA-32e), bit 7 is definitely reserved.
> 
> 	-hpa

There is a separate reserved mask for PS=1, nevermind.

