Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3KHSNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:13:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61941 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757504Ab3KHSNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:13:52 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18I8BYQnbdOpG9PCYb4xEmSaLgC0fnDKZo=
Date: Fri, 8 Nov 2013 13:13:51 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: common location for devicetree files
Message-ID: <20131108181351.GF10335@titan.lakedaemon.net>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
 <20131108165255.GA32668@titan.lakedaemon.net>
 <5957C301-9698-45B0-BFED-749DE79D0A74@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5957C301-9698-45B0-BFED-749DE79D0A74@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 11:59:56AM -0600, Kumar Gala wrote:
> 
> On Nov 8, 2013, at 10:52 AM, Jason Cooper wrote:
> 
> > On Thu, Nov 07, 2013 at 05:21:58PM -0600, Kumar Gala wrote:
> >> As we start having more sharing of device trees between architectures
> >> (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to
> >> live in location that 
> >> 
> >> I was wondering what people felt about doing:
> >> 
> >> 	arch/dts/<VENDOR>/
> >> 
> >> as a common location that could be shared.  I'm up for other
> >> suggestions.
> > 
> > What do we really need to do before the move?  Should all arch dts files
> > be able to #include from any arch?  What's the minimum churn needed to
> > accomplish that?  Maybe just move the needed bits to arch/dts/include/ ?
> > 
> > I'm not real keen on separating by vendor.  For example, us mvebu folks
> > would probably miss useful/duplicated effort in another vendor's
> > subdirectory.  Which was the whole reason for moving driver code out of
> > machine directories to begin with.
> 
> 
> Can you explain that further, what would you miss from other vendors.
> All the patches should still be going via devicetree ML.

I was simply applying the same logic used to justify moving all of the
driver code out of arch/arm/.  Once that happened, a lot of patterns
emerged and we have things like common clock now.  Yet all of this code
(originally under arch/arm) was submitted to the same ML.

iow, there's a difference between being on the same high-traffic
mailinglist where people are filtering out just what they need, and
being in the same subdirectory, right next to three other
implementations of the same code (I exaggerate, but the point remains).
It's a lot easier to spot similar implementations when they are all
congregated under one directory.

How many boards are using the same PMIC across vendors?  Would it make
sense to have a tps6905.dtsi they could all include?  Flash chips?  I'm
just asking.

My gut is that having separate vendor directories would lead to
balkanization.  That might not be a problem, but it's worth considering.

thx,

Jason.
