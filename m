Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3CSDgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:36:55 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51650 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3CSDgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <1938905.m8UJXV94pZ@avalon>
References: <20130313113203.30133.49539.sendpatchset@w520>
	<1670937.hEFtzrbkf6@avalon>
	<CANqRtoSDc6YfnotMR2aw4niEYyjn1C7JRu4WciyKsP-QT+j4LA@mail.gmail.com>
	<1938905.m8UJXV94pZ@avalon>
Date: Tue, 19 Mar 2013 12:36:52 +0900
Message-ID: <CANqRtoRBfjXgGt4_niN3m5ULVQVQXBBARLUkNPyeDnZLatgXKA@mail.gmail.com>
Subject: Re: [PATCH 00/03] gpio: Renesas R-Car GPIO driver update
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, Mar 14, 2013 at 10:13 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Thursday 14 March 2013 13:23:46 Magnus Damm wrote:
>> On Wed, Mar 13, 2013 at 9:58 PM, Laurent Pinchart wrote:
>> > On Wednesday 13 March 2013 20:32:03 Magnus Damm wrote:
>> >> gpio: Renesas R-Car GPIO driver update
>> >>
>> >> [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
>> >> [PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
>> >> [PATCH 03/03] gpio: rcar: Make use of devm functions
>> >>
>> >> This series updates the R-Car GPIO driver with various
>> >> changes kindly suggested by Laurent Pinchart.
>> >>
>> >> Patch [01/03] is a drop in replacement for V1 of the R-Car
>> >> GPIO driver. The flag in patch [02/03] is kept out of [01/03]
>> >> to avoid changing the behaviour of the driver between V1 and V2.
>> >> Also, devm support in [03/03] is kept out of [01/03] to make
>> >> sure back porting goes as smooth as possible.
>> >
>> > As I mentioned in a previous e-mail, all the devm_* functions used in
>> > 03/03 have been available since 2.6.30. Do you really need to port that
>> > driver to older kernels ?
>>
>> Well, it was earlier suggested to me that not using devm to begin with
>> is a safe way forward for back porting. Also, as the individual patch
>> shows, we save about 10 lines of code but add many more complex
>> dependencies.
>>
>> Simon, do you have any recommendation how for us regarding devm and
>> back porting?
>>
>> > Regarding 02/03, do you plan to squash it with 01/03 for the mainline
>> > submission ?
>>
>> Not unless someone puts a gun to my head. =) Of course, if a single
>> patch is really required then I will follow that, but I can't really
>> see why when we have a nice versioning control system that can help
>> our development in various ways.
>>
>> What is the reason behind you wanting to merge these patches?
>>
>> From my point of view, if any incremental patch was a bug fix then i
>> would of course request to fold it in, but in this case these are
>> feature patches that would be beneficial to keep as individual
>> commits. Keeping them separate allows us to bisect and also makes
>> partial back porting easier if needed.
>
> When submitting new drivers I usually try not to make the development history
> visible to mainline. It brings little additional value (beside possibly making
> backporting a bit easier, but in the devm_* case that shouldn't be a problem,
> unless Simon thinks otherwise) but adds review complexity, as reviewers need
> to validate the intermediate versions as well. More patches also mean more
> potential bisection breakages.

Huh, it seems that my point of view is the total opposite. I see that
using incremental patches to show new development would make review
_easier_. Perhaps that's not the case for most people.

Regarding bisection, having features broken out actually allows us to
bisect compared to a single commit. I see that as a feature. Of course
the developer needs to make sure that the incremental changes do not
cause any breakages, but if the developer can't do that then there are
other more serious issues that need to be fixed IMO.

> In this case (assuming there would be no backporting issue) there's no need
> for mainline to see that we started with a version that didn't use devm_* and
> then modified the code. I see no added value in that.

So say that you write a driver and add say 8 features on top of that
over time, wouldn't it make sense to share that information with other
people? That way any party can bisect and locate issues that may come
up. I find that useful regardless if the code is back ported or not.

Anyway, with this particular driver it doesn't really matter since the
complexity is very low. And now Simon has gotten back to us with
updated information about back porting.

I will pull it all together into a V3.

Thanks,

/ magnus
