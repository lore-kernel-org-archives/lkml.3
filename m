Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3IXUKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:10:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:13094 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3IXUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:10:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Dfzy/eOsjYS0MYQfgimox
Date: Tue, 24 Sep 2013 13:10:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Paul Walmsley <paul@pwsan.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20130924201005.GB8949@atomide.com>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
 <5240A617.1010208@wwwdotorg.org>
 <20130923234656.GB24781@earth.universe>
 <5241EE47.5050907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241EE47.5050907@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130924 13:03]:
> On 09/23/2013 05:46 PM, Sebastian Reichel wrote:
> > Hi,
> > 
> > On Mon, Sep 23, 2013 at 02:35:35PM -0600, Stephen Warren wrote:
> >> On 09/15/2013 02:44 PM, Sebastian Reichel wrote:
> >>> Add SSI device tree data for OMAP34xx and Nokia N900.
> 
> ...
> >>> +- ti,hwmods:		Name of the hwmod associated to the controller,
> >>> which +			is "ssi".
> >> 
> >> I don't think we should add any more of that, for new bindings.
> > 
> > That basically means not adding new drivers until hwmod is
> > completly removed, since no new drivers not using DT are accepted
> > anymore.
> > 
> > hwmod still holds some information, which are not yet mapped to
> > DT.
> 
> Tony, is defining hwmod properties for new OMAP bindings what everyone
> is currently doing? I'm not sure how that will work with a stable DT
> ABI...
> 
> I wonder if it makes sense not to define the ti,hwmods property in the
> binding document (so it doesn't become part of the ABI), but put it
> into the DTS file simply to make the current Linux code work? I'm not
> sure if that's any better though.

There are still pieces of information in hwmod that is needed for
PM to work for things like device autoidle and reset. The plan is
to describe those with Linux generic bindings, but that's going
to take a while.

Clearly once we have those bindings, ti,hwmods is not needed and
then the problem is how to support old .dtb files..

> It would be best to completely define the DT binding so that all
> required clocks etc. are already present in the DT. That way, the DT
> ABI won't change once people stop using hwmods. Tony, is that possible
> on OMAP at present, irrespective of whether those e.g. clock
> properties will actually be used by Linux?

Unfortunately not doable yet. For v3.13 we should have the
clock bindings in place, but quite a bit of work still
remains for the remaining hwmod pieces.

Considering all this, we may be best off dropping ti,hwmods
binding completely, and populate it based on DT auxdata or
something similar. That means that old .dtb files won't
work once we populate things from DT, but at least the binding
issue would be sorted out.

If anybody has better suggestions, let me know.

Regards,

Tony
