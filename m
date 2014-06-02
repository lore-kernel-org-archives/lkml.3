Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaFBBzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:55:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaFBBzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:55:46 -0400
X-AuditID: cbfee68f-b7fef6d000003970-06-538bd99f2046
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: "'Grant Likely'" <grant.likely@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Leilei Shang'" <shangll@marvell.com>,
        "'Daniel Drake'" <dsd@laptop.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1400346848-25098-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140601202647.GD3853@katana>
In-reply-to: <20140601202647.GD3853@katana>
Subject: Re: [PATCH] i2c: busses: i2c-pxa.c:  Fix for possible null pointer
 dereference
Date: Mon, 02 Jun 2014 10:55:43 +0900
Message-id: <004801cf7e05$c3354c20$499fe460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9919ThpWs4mLR8QM2ZLGshrTT/rQALNpTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+Zke78m93BBhtnKFjMP3KO1WL+7Ims
	Fgf+7GC0uLzwEqtFx98vQNauOWwWp3feZLVo3XuE3aLj5UE2i5UnZjE7cHlsWtXJ5nHoylpG
	jzvX9rB5TF54kdmjb8sqRo/2hp+MHidPPWHx+LxJLoAjissmJTUnsyy1SN8ugSujedopxoLX
	XBV395xnaWC8zdHFyMkhIWAiceXCP2YIW0ziwr31bF2MXBxCAssYJT6sWMIOU9Q+oR0qsYhR
	4uTXF1DOb0aJld9XMoFUsQmoSXz5chiog4NDRCBDYuoOVZAaZoEZTBK/bk0HqxESqJSY8ugW
	G4jNKaAtcXFXP5gtLBApcbzlEAuIzSKgKjH51SdWEJtXwFZi+YTtzBC2oMSPyffAapgFtCTW
	7zzOBGHLS2xe85YZZK+EgLrEo7+6IGERASOJl19eQJWISOx78Y4R5B4JgZkcEqce3GGE2CUg
	8W0yyF6QXlmJTQegISEpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRsV5x
	Ym5xaV66XnJ+7iZGSOz372C8e8D6EGMy0PqJzFKiyfnA1JFXEm9obGZkYWpiamxkbmlGmrCS
	OO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhjj1nScUtphfD7q7W/TuLMrbzzWqmqV
	vG+zQvP9+5yA3DlXEwILrp04YfnoBcvP16bus9Wqnnq+OlZpMmlSR+f5CutZ3VO6vwrqPrmt
	cf3+Lduf87W15BUyvp+eW7wzJKlnR/7cM/FOT3+vmSG6WEbLw+b3YcuXwk96XLpPPD/zQmjR
	XrY7SUl3lFiKMxINtZiLihMBi3dBqhMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jAd35N7uDDZaul7aYf+Qcq8X82RNZ
	LQ782cFocXnhJVaLjr9fgKxdc9gsTu+8yWrRuvcIu0XHy4NsFitPzGJ24PLYtKqTzePQlbWM
	Hneu7WHzmLzwIrNH35ZVjB7tDT8ZPU6eesLi8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QlUoKZYk5pUChgMTiYiV9O0wTQkPcdC1g
	GiN0fUOC4HqMDNBAwjrGjOZppxgLXnNV3N1znqWB8TZHFyMnh4SAiUT7hHY2CFtM4sK99UA2
	F4eQwCJGiZNfX0A5vxklVn5fyQRSxSagJvHly2H2LkYODhGBDImpO1RBapgFZjBJ/Lo1HaxG
	SKBSYsqjW2BTOQW0JS7u6gezhQUiJY63HGIBsVkEVCUmv/rECmLzCthKLJ+wnRnCFpT4Mfke
	WA2zgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQsImAk8fLLC6gSEYl9L94xTmAUmoVk0iwk
	k2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGJ5ZnUDsaVDRaHGAU4GJV4
	eCcs6AoWYk0sK67MPcQowcGsJMJ79Gx3sBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA5Ne
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwlqRG3ljbl/Vh
	cmGUwNLOFNMf/gIcHzTmXufoqoz3dpNkWh6/rz551jRh3r9/tJZ7iawUCzv+bOpOI5X/XI4r
	PY3Nmw+suSYn2Tf3maPQwRZj6b9utouk3c/9Xcv/6KGry/Ffl/Ra5K/Xb1x4suKS0gk35z3m
	f1Lsv20X0/PJFuRbEOC0y26iEktxRqKhFnNRcSIAeH78UHADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 02, 2014 5:27 AM, Wolfram Sang wrote:
> On Sat, May 17, 2014 at 07:14:08PM +0200, Rickard Strandqvist wrote:
> > There is otherwise a risk of a possible null pointer dereference.
> >
> > Was largely found by using a static code analysis program called cppcheck.
> 
> It is useful to put the output of the analyzer here.
> 
> >
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> >  drivers/i2c/busses/i2c-pxa.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> > index bbe6dfb..dbe5ebe 100644
> > --- a/drivers/i2c/busses/i2c-pxa.c
> > +++ b/drivers/i2c/busses/i2c-pxa.c
> > @@ -1269,7 +1269,9 @@ eremap:
> >  eclk:
> >  	kfree(i2c);
> >  emalloc:
> > -	release_mem_region(res->start, resource_size(res));
> > +	if(res) {
> > +		release_mem_region(res->start, resource_size(res));
> > +	}
> 
> The proper fix is to move the release to the proper place, before kfree.
> Even better would probably be a devm_* conversion.

+1

I agree with Wolfram Sang's opinion. Please call release_mem_region()
prior to kfree().

One more thing, don't use braces when a single statement
is used. Please refer to 'Chapter 3: Placing Braces and Spaces'
of 'Documentation/CodingStyle'.

Best regards,
Jingoo Han

