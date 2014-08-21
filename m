Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaHULrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbaHULrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:47:51 -0400
Date: Thu, 21 Aug 2014 13:47:40 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/6] KVM: VMX: dynamise PLE window
Message-ID: <20140821114739.GC20546@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-5-git-send-email-rkrcmar@redhat.com>
 <53F5ACCB.8000201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5ACCB.8000201@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 10:24+0200, Paolo Bonzini:
> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> > +static void update_ple_window_actual_max(void)
> > +{
> > +	ple_window_actual_max =
> > +			__shrink_ple_window(max(ple_window_max, ple_window),
> 
> Why the max() here?

To have ple_window act as a ple_window_min as well.
(When we are already preventing most stupid choices.)

And it's cheap ... I can add comment to this function :)

> > +			                    ple_window_grow, INT_MIN);
> 
> This should be 0 (in fact you can probably make everything unsigned now
> that you've sorted out the overflows).

Not in v2:
  val = min(vmx->ple_window, ple_window_actual_max);
  val += ple_window_grow;
  vmx->ple_window = val;
so we need to dip below zero to allow all possible grows.

(I'm not sure if anyone is ever going to use the additive option, so
 getting rid of it is also a valid choice -- code would be nicer.)
