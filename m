Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaJTPJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:09:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaJTPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:09:45 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-a4-544525b638f9
Message-id: <1413817781.11298.0.camel@AMDC1943>
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
Date: Mon, 20 Oct 2014 17:09:41 +0200
In-reply-to: <20141020150630.GB26784@x1>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
 <20141020150630.GB26784@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7rbVF1DDO736VlsnLGe1WLSk/fM
	FvOPnGO1mLhyMrPF2aY37Bb3vx5ltNj8vYPN4vKuOWwWn3uPMFqsPXKX3eJ0N6vF6d0lDjwe
	O2fdZffYvELLY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBlL3m5i
	LbjKWfF181yWBsYz7F2MnBwSAiYSO6fuYIGwxSQu3FvP1sXIxSEksJRRYv2Ww1DOZ0aJtasm
	M4JU8QroSyxomAvWISwQIHHnyw9WEJtNwFhi8/IlQA0cHCICKhLn3piD9DILrGOWWLR1NVg9
	i4CqxIJb98DmcApoSMx8eIYFYsFCRonrT88wgSSYBdQlJs1bxAwySEJAWaKx3w1ir6DEj8n3
	WCBK5CU2r3nLPIFRYBaSjllIymYhKVvAyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyRK
	vu5gXHrM6hCjAAejEg/vDjOXECHWxLLiytxDjBIczEoivAoqriFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGCs2ucU5cBy24WLMWelkaO0Q8LUor1DP7f/Bix+4o011l1UkFXNw3ti+O3En563N
	8rahHJI1C+LWnFQ8e63b0vhe4l5e3RcqrlYGmozl22MnGBo9l5o5QaJMfpYpv9OhlT6mV+zy
	hRQPRoQ6rZph0rfIqHNl8r6wyz9q3Grev3O5zXp1e0uOEktxRqKhFnNRcSIA4qtVd3ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-20 at 16:06 +0100, Lee Jones wrote:
> On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
> > child device (the charger) will have its own of_node set. This will be
> > used by the max77693 charger driver in next patches to obtain battery
> > configuration from DTS.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/max77693.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > index cf008f45968c..2277a11b6629 100644
> > --- a/drivers/mfd/max77693.c
> > +++ b/drivers/mfd/max77693.c
> > @@ -43,7 +43,10 @@
> >  
> >  static const struct mfd_cell max77693_devs[] = {
> >  	{ .name = "max77693-pmic", },
> > -	{ .name = "max77693-charger", },
> > +	{
> > +		.name = "max77693-charger",
> > +		.of_compatible = "maxim,max77693-charger",
> > +	},
> >  	{ .name = "max77693-muic", },
> >  	{ .name = "max77693-haptic", },
> >  	{
> 
> I'm guessing this can be applied separately?

Yes. Patch 3/5 also (it adds necessary defines and symbols for
chargers).

Best regards,
Krzysztof

