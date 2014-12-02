Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbaLBVDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:03:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365AbaLBVDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:03:07 -0500
Date: Tue, 2 Dec 2014 22:03:01 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 5/5] kvm: optimize GFN to memslot lookup with large slots
 amount
Message-ID: <20141202210300.GA13037@potion.redhat.com>
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com>
 <1417454967-4465-6-git-send-email-imammedo@redhat.com>
 <20141202173350.GA11312@potion.brq.redhat.com>
 <547E08C1.3090708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547E08C1.3090708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-02 19:45+0100, Paolo Bonzini:
> On 02/12/2014 18:33, Radim Krčmář wrote:
> >> > +	while (start < end) {
> >> > +		slot = start + (end - start) / 2;
> >> > +
> >> > +		if (gfn >= memslots[slot].base_gfn)
> > (Even thought division is costly, I think that checking here if 'slot'
> >  is the one we want wouldn't help very much.)
> > 
> 
> Division by an unsigned is just a right shift.  Division by signed
> integer is a right shift + conditional move.  We can change / 2 to
> explicit >> 1, or change start and end to unsigned, or both.

My bad, no respectable optimizer would miss that.
