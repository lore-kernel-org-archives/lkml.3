Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3CSPAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:00:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38013 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3CSPAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:00:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
Date: Tue, 19 Mar 2013 16:01:21 +0100
Message-ID: <6201076.rrbXElODM8@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
References: <20130313113203.30133.49539.sendpatchset@w520> <1938905.m8UJXV94pZ@avalon> <CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tuesday 19 March 2013 12:36:52 Magnus Damm wrote:
> On Thu, Mar 14, 2013 at 10:13 PM, Laurent Pinchart wrote:
> > On Thursday 14 March 2013 13:23:46 Magnus Damm wrote:
> >> On Wed, Mar 13, 2013 at 9:58 PM, Laurent Pinchart wrote:
> >> > On Wednesday 13 March 2013 20:32:03 Magnus Damm wrote:
> >> >> gpio: Renesas R-Car GPIO driver update
> >> >> 
> >> >> [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
> >> >> [PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
> >> >> [PATCH 03/03] gpio: rcar: Make use of devm functions
> >> >> 
> >> >> This series updates the R-Car GPIO driver with various
> >> >> changes kindly suggested by Laurent Pinchart.
> >> >> 
> >> >> Patch [01/03] is a drop in replacement for V1 of the R-Car
> >> >> GPIO driver. The flag in patch [02/03] is kept out of [01/03]
> >> >> to avoid changing the behaviour of the driver between V1 and V2.
> >> >> Also, devm support in [03/03] is kept out of [01/03] to make
> >> >> sure back porting goes as smooth as possible.
> >> > 
> >> > As I mentioned in a previous e-mail, all the devm_* functions used in
> >> > 03/03 have been available since 2.6.30. Do you really need to port that
> >> > driver to older kernels ?
> >> 
> >> Well, it was earlier suggested to me that not using devm to begin with
> >> is a safe way forward for back porting. Also, as the individual patch
> >> shows, we save about 10 lines of code but add many more complex
> >> dependencies.
> >> 
> >> Simon, do you have any recommendation how for us regarding devm and
> >> back porting?
> >> 
> >> > Regarding 02/03, do you plan to squash it with 01/03 for the mainline
> >> > submission ?
> >> 
> >> Not unless someone puts a gun to my head. =) Of course, if a single
> >> patch is really required then I will follow that, but I can't really
> >> see why when we have a nice versioning control system that can help
> >> our development in various ways.
> >> 
> >> What is the reason behind you wanting to merge these patches?
> >> 
> >> From my point of view, if any incremental patch was a bug fix then i
> >> would of course request to fold it in, but in this case these are
> >> feature patches that would be beneficial to keep as individual
> >> commits. Keeping them separate allows us to bisect and also makes
> >> partial back porting easier if needed.
> > 
> > When submitting new drivers I usually try not to make the development
> > history visible to mainline. It brings little additional value (beside
> > possibly making backporting a bit easier, but in the devm_* case that
> > shouldn't be a problem, unless Simon thinks otherwise) but adds review
> > complexity, as reviewers need to validate the intermediate versions as
> > well. More patches also mean more potential bisection breakages.
> 
> Huh, it seems that my point of view is the total opposite. I see that
> using incremental patches to show new development would make review
> _easier_. Perhaps that's not the case for most people.
>
> Regarding bisection, having features broken out actually allows us to
> bisect compared to a single commit. I see that as a feature. Of course
> the developer needs to make sure that the incremental changes do not
> cause any breakages, but if the developer can't do that then there are
> other more serious issues that need to be fixed IMO.
> 
> > In this case (assuming there would be no backporting issue) there's no
> > need for mainline to see that we started with a version that didn't use
> > devm_* and then modified the code. I see no added value in that.
> 
> So say that you write a driver and add say 8 features on top of that
> over time, wouldn't it make sense to share that information with other
> people? That way any party can bisect and locate issues that may come
> up. I find that useful regardless if the code is back ported or not.

Long answer short: it depends :-)

If you add features incrementally, submitting them as individual patches 
totally make sense. However, if your patches aim at simplifying the code 
instead of adding features (such as devm_* usage), individual patches make it 
more complex in my opinion. Reviewers will need to look at the intermediate, 
more complex code, to make sure that no bisection breakage points will be 
introduced. Squashing the patches together then make review easier (as there's 
less code to review) and don't really hurt bisection, as the simplification 
patches usually remove code and thus bugs.

> Anyway, with this particular driver it doesn't really matter since the
> complexity is very low. And now Simon has gotten back to us with updated
> information about back porting.
> 
> I will pull it all together into a V3.

Thank you :-)

-- 
Regards,

Laurent Pinchart

