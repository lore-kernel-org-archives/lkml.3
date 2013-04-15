Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3DOU3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:29:34 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:65187 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3DOU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:29:33 -0400
Date: Mon, 15 Apr 2013 13:29:34 -0700
From: Olof Johansson <olof@lixom.net>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Axel Lin <axel.lin@ingics.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: vt8500: wmt: Fix checking return value of
 pinctrl_register()
Message-ID: <20130415202934.GB25053@quad.lixom.net>
References: <1365523198.12439.1.camel@phoenix>
 <51646C5C.7080108@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51646C5C.7080108@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 07:30:36AM +1200, Tony Prisk wrote:
> On 10/04/13 03:59, Axel Lin wrote:
> >pinctrl_register() returns NULL on error.
> >
> >Signed-off-by: Axel Lin <axel.lin@ingics.com>
> >---
> >  drivers/pinctrl/vt8500/pinctrl-wmt.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> >index 14400a7..ab63104e 100644
> >--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> >+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> >@@ -588,7 +588,7 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
> >  	data->dev = &pdev->dev;
> >  	data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
> >-	if (IS_ERR(data->pctl_dev)) {
> >+	if (!data->pctl_dev) {
> >  		dev_err(&pdev->dev, "Failed to register pinctrl\n");
> >  		return -EINVAL;
> >  	}
> Not sure why I missed this...
> 
> Linus,
> If you're happy with this patch, I'll forward it on to arm-soc to go
> in with the rest.

I was asked to apply this directly, and have done so (to next/drivers).


-Olof
