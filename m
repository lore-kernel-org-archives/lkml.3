Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaJUKUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:20:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63810 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaJUKUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:20:50 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-d2-5446337fabce
Message-id: <1413886845.26980.18.camel@AMDC1943>
Subject: Re: [PATCH v2 2/5] mfd: max77693: Map charger device to its own of_node
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-api@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 21 Oct 2014 12:20:45 +0200
In-reply-to: <20141021101705.GF26842@x1>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
 <20141020150630.GB26784@x1> <1413817781.11298.0.camel@AMDC1943>
 <20141021101705.GF26842@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xK7r1xm4hBi+n6FtsnLGe1WLSk/fM
	FvOPnGO1mLhyMrPF2aY37Bb3vx5ltNj8vYPN4vKuOWwWn3uPMFqsPXKX3eJ0N6vF6d0lDjwe
	O2fdZffYvELLY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBl7j7gW
	POGpWHXyN0sD4w3OLkZODgkBE4nV03YwQthiEhfurWfrYuTiEBJYyihxd/17ZgjnM6PEwf5W
	sCpeAQOJh4cnsoLYwgIBEne+/ACz2QSMJTYvXwLUzcEhIqAice6NOUgvs8A6ZolFW1ezgNSw
	CKhKnH7eDzaHU0BD4v/JLqhtj4EWHFwMVsQsoC4xad4iZpBBEgLKEo39bhB7BSV+TL4HVSIv
	sXnNW+YJjAKzkHTMQlI2C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghMfJlB+Pi
	Y1aHGAU4GJV4eDcscw0RYk0sK67MPcQowcGsJMKbK+wWIsSbklhZlVqUH19UmpNafIiRiYNT
	qoEx9Lbt5jl8MU4ML5utFsYKGx9p+/nL8YJnaZ5KD6v+qY8c6oYT4jz6dD9ruj6expPz9vZy
	67thzYcKnz5ZumIe9803VYFP4gP2f85YeWT+6jOnlJl3uOvVmPc4pOXvsG9b0B6q7L3v5d/Q
	+cmBE2tYo7LT7q1yKq7keHD+e8fuh6ylDJPmvZqtxFKckWioxVxUnAgAfI25Xm8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 11:17 +0100, Lee Jones wrote:
> On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > On pon, 2014-10-20 at 16:06 +0100, Lee Jones wrote:
> > > On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> > > 
> > > > Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
> > > > child device (the charger) will have its own of_node set. This will be
> > > > used by the max77693 charger driver in next patches to obtain battery
> > > > configuration from DTS.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > > ---
> > > >  drivers/mfd/max77693.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > > > index cf008f45968c..2277a11b6629 100644
> > > > --- a/drivers/mfd/max77693.c
> > > > +++ b/drivers/mfd/max77693.c
> > > > @@ -43,7 +43,10 @@
> > > >  
> > > >  static const struct mfd_cell max77693_devs[] = {
> > > >  	{ .name = "max77693-pmic", },
> > > > -	{ .name = "max77693-charger", },
> > > > +	{
> > > > +		.name = "max77693-charger",
> > > > +		.of_compatible = "maxim,max77693-charger",
> > > > +	},
> > > >  	{ .name = "max77693-muic", },
> > > >  	{ .name = "max77693-haptic", },
> > > >  	{
> > > 
> > > I'm guessing this can be applied separately?
> > 
> > Yes. Patch 3/5 also (it adds necessary defines and symbols for
> > chargers).
> 
> I'll take this patch, but I think 3/5 is required by some of the other
> patches in the set, no?

Yes, it is required by 4/5 (charger driver).

Best regards,
Krzysztof


