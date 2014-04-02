Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbaDBKyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:54:31 -0400
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:48756 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758161AbaDBKy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:54:27 -0400
Message-ID: <1396436064.3554.53.camel@linaro1.home>
Subject: Re: Bug(?) in patch "arm64: Implement coherent DMA API based on
 swiotlb" (was Re: [GIT PULL] arm64 patches for 3.15)
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Date: Wed, 02 Apr 2014 11:54:24 +0100
In-Reply-To: <20140402092032.GB31892@arm.com>
References: <20140331175230.GA7480@arm.com>
	 <1396368657.3681.17.camel@linaro1.home> <20140401172939.GG20061@arm.com>
	 <1396428722.3554.20.camel@linaro1.home> <20140402092032.GB31892@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 10:20 +0100, Catalin Marinas wrote:
> On Wed, Apr 02, 2014 at 09:52:02AM +0100, Jon Medhurst (Tixy) wrote:
> > On Tue, 2014-04-01 at 18:29 +0100, Catalin Marinas wrote:

> > > +1:	tst	x0, x3				// start cache line aligned?
> > > +	bic	x0, x0, x3
> > > +	b.eq	2f
> > > +	dc	civac, x0			// clean & invalidate D / U line
> > > +	b	3f
> > > +2:	dc	ivac, x0			// invalidate D / U line
> > > +3:	add	x0, x0, x2
> > >  	cmp	x0, x1
> > >  	b.lo	1b
> > 
> > The above obviously also needs changing to branch to 3b
> 
> Good point.

Actually, it should be 2b :-)

-- 
Tixy

