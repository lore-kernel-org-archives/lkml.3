Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaEORHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:07:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42015 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaEORHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:07:16 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-de-5374f442cc9b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_control()
Date: Thu, 15 May 2014 19:06:58 +0200
Message-id: <2117889.Z2oDTHJSPp@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140515150308.GC27690@developer>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1399288539-1793-10-git-send-email-b.zolnierkie@samsung.com>
 <20140515150308.GC27690@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAV2nLyXBBj9Ocls0XA2xWLP/J5PF
	/CvXWC3ONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PLYOesuu8fiPS+Z
	PLZcbWfx6NuyitHj+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZfS/2stacFyoYs7VG2wNjLP5
	uxg5OCQETCSOvanqYuQEMsUkLtxbz9bFyMUhJLCIUeL67cVQTguTxMr1v1lBqtgErCQmtq9i
	BLFFBLQkTlzazgRSxCxwk0ni8K8fLCAJYYFUiSlTd4MVsQioSuyfM5kdxOYV0JT4sWIJWI2o
	gKfEju0r2UCu4BTQl+j6KAixbDWjxIQb11kh6gUlfky+B1bPLCAvsW//VFYIW0ti/c7jTBMY
	BWYhKZuFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj4ZnUDsaVDRaHGAU4
	GJV4eBkmFwcLsSaWFVfmHmKU4GBWEuE1f14SLMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1
	oJBAemJJanZqakFqEUyWiYNTqoExvsDpCP+fC+F9a/XOCoX7zNxVM2n6f02P1t/LDu3OlOJ8
	cMsu1+7yP4eNDjursh6urZGcYhSw1K+7LnLhFY0uWTke40Y3nTWJyambnt8MPJC0Sttu6bSP
	k8vtLrgo7WZ/wGAid+OKZ9+tJ0pRB/dsy5s8pUDHxfsQ9xqDvqI/+165LeXL/cOqxFKckWio
	xVxUnAgATT48oYICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 11:03:08 AM Eduardo Valentin wrote:
> Hello Bartlomiej,

Hi,

> On Mon, May 05, 2014 at 01:15:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > pdata->reference_voltage and pdata->gain are always defined
> > to non-zero values so remove the redundant checks from
> > exynos_tmu_control().
> > 
> 
> In all existing SoCs? 

Yes.

> Should this be considered to any upcoming SoCs?

Yes, if/when it changes we will update the code.

> > There should be no functional changes caused by this patch.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index a8d9524..45d7c6f 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -215,15 +215,11 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
> >  	if (pdata->test_mux)
> >  		con |= (pdata->test_mux << reg->test_mux_addr_shift);
> >  
> > -	if (pdata->reference_voltage) {
> > -		con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
> > -		con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
> > -	}
> > +	con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
> > +	con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
> >  
> > -	if (pdata->gain) {
> > -		con &= ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
> > -		con |= (pdata->gain << reg->buf_slope_sel_shift);
> > -	}
> > +	con &= ~(reg->buf_slope_sel_mask << reg->buf_slope_sel_shift);
> > +	con |= (pdata->gain << reg->buf_slope_sel_shift);
> 
> The way it is put, looks like gain and reference_voltage are mandatory
> pdata fields. Should these checks be moved to initialization phase?

Yes, they should be considered mandatory pdata fields but I'm against
adding any superfluous pdata checks for initialization phase (I will
update struct exynos_tmu_platform_data documentation to indicate that
these fields cannot be zero instead).

> >  	if (pdata->noise_cancel_mode) {
> >  		con &= ~(reg->therm_trip_mode_mask <<

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

