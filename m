Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3CNEXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:23:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:64635 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3CNEXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <1670937.hEFtzrbkf6@avalon>
References: <20130313113203.30133.49539.sendpatchset@w520>
	<1670937.hEFtzrbkf6@avalon>
Date: Thu, 14 Mar 2013 13:23:46 +0900
Message-ID: <CANqRtoSDc6YfnotMR2aw4niEYyjn1C7JRu4WciyKsP-QT+j4LA@mail.gmail.com>
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

Hi Laurent, Simon,

On Wed, Mar 13, 2013 at 9:58 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> Thanks for the patches.

Thanks for your review!

> On Wednesday 13 March 2013 20:32:03 Magnus Damm wrote:
>> gpio: Renesas R-Car GPIO driver update
>>
>> [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
>> [PATCH 02/03] gpio: rcar: Use IRQCHIP_SET_TYPE_MASKED
>> [PATCH 03/03] gpio: rcar: Make use of devm functions
>>
>> This series updates the R-Car GPIO driver with various
>> changes kindly suggested by Laurent Pinchart.
>>
>> Patch [01/03] is a drop in replacement for V1 of the R-Car
>> GPIO driver. The flag in patch [02/03] is kept out of [01/03]
>> to avoid changing the behaviour of the driver between V1 and V2.
>> Also, devm support in [03/03] is kept out of [01/03] to make
>> sure back porting goes as smooth as possible.
>
> As I mentioned in a previous e-mail, all the devm_* functions used in 03/03
> have been available since 2.6.30. Do you really need to port that driver to
> older kernels ?

Well, it was earlier suggested to me that not using devm to begin with
is a safe way forward for back porting. Also, as the individual patch
shows, we save about 10 lines of code but add many more complex
dependencies.

Simon, do you have any recommendation how for us regarding devm and
back porting?

> Regarding 02/03, do you plan to squash it with 01/03 for the mainline
> submission ?

Not unless someone puts a gun to my head. =) Of course, if a single
patch is really required then I will follow that, but I can't really
see why when we have a nice versioning control system that can help
our development in various ways.

What is the reason behind you wanting to merge these patches?

>From my point of view, if any incremental patch was a bug fix then i
would of course request to fold it in, but in this case these are
feature patches that would be beneficial to keep as individual
commits. Keeping them separate allows us to bisect and also makes
partial back porting easier if needed.

Thanks,

/ magnus
