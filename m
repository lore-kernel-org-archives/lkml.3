Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3CPIui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 04:50:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50721 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3CPIuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 04:50:35 -0400
Date: Sat, 16 Mar 2013 09:50:28 +0100
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca
Subject: Re: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
Message-ID: <20130316085027.GA4075@verge.net.au>
References: <20130313113203.30133.49539.sendpatchset@w520>
 <1670937.hEFtzrbkf6@avalon>
 <CANqRtoSDc6YfnotMR2aw4niEYyjn1C7JRu4WciyKsP-QT+j4LA@mail.gmail.com>
 <1938905.m8UJXV94pZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1938905.m8UJXV94pZ@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 02:13:52PM +0100, Laurent Pinchart wrote:
> Hi Magnus,
> 
> On Thursday 14 March 2013 13:23:46 Magnus Damm wrote:
> > On Wed, Mar 13, 2013 at 9:58 PM, Laurent Pinchart wrote:
> > > On Wednesday 13 March 2013 20:32:03 Magnus Damm wrote:
> > >> gpio: Renesas R-Car GPIO driver update
> > >> 
> > >> [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
> > >> [PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
> > >> [PATCH 03/03] gpio: rcar: Make use of devm functions
> > >> 
> > >> This series updates the R-Car GPIO driver with various
> > >> changes kindly suggested by Laurent Pinchart.
> > >> 
> > >> Patch [01/03] is a drop in replacement for V1 of the R-Car
> > >> GPIO driver. The flag in patch [02/03] is kept out of [01/03]
> > >> to avoid changing the behaviour of the driver between V1 and V2.
> > >> Also, devm support in [03/03] is kept out of [01/03] to make
> > >> sure back porting goes as smooth as possible.
> > > 
> > > As I mentioned in a previous e-mail, all the devm_* functions used in
> > > 03/03 have been available since 2.6.30. Do you really need to port that
> > > driver to older kernels ?

Not that I am aware of.

Actually, I am not aware of any serious back-porting to anything
older than LTSI-3.4.25.

> > Well, it was earlier suggested to me that not using devm to begin with
> > is a safe way forward for back porting. Also, as the individual patch
> > shows, we save about 10 lines of code but add many more complex
> > dependencies.
> > 
> > Simon, do you have any recommendation how for us regarding devm and
> > back porting?

I see devm_* in LTSI-3.4.25 so unless I am missing something I don't
think there will be back-porting implications for you writing your
code against those functions.

> > > Regarding 02/03, do you plan to squash it with 01/03 for the mainline
> > > submission ?
> > 
> > Not unless someone puts a gun to my head. =) Of course, if a single
> > patch is really required then I will follow that, but I can't really
> > see why when we have a nice versioning control system that can help
> > our development in various ways.
> > 
> > What is the reason behind you wanting to merge these patches?
> > 
> > From my point of view, if any incremental patch was a bug fix then i
> > would of course request to fold it in, but in this case these are
> > feature patches that would be beneficial to keep as individual
> > commits. Keeping them separate allows us to bisect and also makes
> > partial back porting easier if needed.
> 
> When submitting new drivers I usually try not to make the development history 
> visible to mainline. It brings little additional value (beside possibly making 
> backporting a bit easier, but in the devm_* case that shouldn't be a problem, 
> unless Simon thinks otherwise) but adds review complexity, as reviewers need 
> to validate the intermediate versions as well. More patches also mean more 
> potential bisection breakages.
> 
> In this case (assuming there would be no backporting issue) there's no need 
> for mainline to see that we started with a version that didn't use devm_* and 
> then modified the code. I see no added value in that.

+1
