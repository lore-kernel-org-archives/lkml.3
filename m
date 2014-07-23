Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbaGWQLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:11:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52226 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744AbaGWQLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:11:44 -0400
Message-ID: <1406131883.2585.45.camel@iivanov-dev>
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller
 driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 23 Jul 2014 19:11:23 +0300
In-Reply-To: <CACRpkdaCfrjNmkuRYVwdDHdt4myNkmTwmJjZU3AQr1SsSKBS3g@mail.gmail.com>
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>
	 <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>
	 <CACRpkdaCfrjNmkuRYVwdDHdt4myNkmTwmJjZU3AQr1SsSKBS3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 17:27 +0200, Linus Walleij wrote:
> On Thu, Jul 17, 2014 at 5:25 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> 
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >
> > This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> > Qualcomm GPIO and MPP sub-function blocks found in the PMIC chips.
> >
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> (...)
> > +static int qpnp_pinctrl_remove(struct platform_device *pdev)
> > +{
> > +       struct qpnp_pinctrl *qctrl = platform_get_drvdata(pdev);
> > +
> > +       pinctrl_unregister(qctrl->ctrl);
> > +
> > +       return gpiochip_remove(&qctrl->chip);
> 
> We're removing the return value from gpiochip_remove() and I
> have dropped the __must_check attribute today, so just remove
> it unconditionally and return 0;

Yes, I know. Patches are based on v3.16-rc6 tag.

> 
> Sorry for short and lame comment on a large patch I should look
> closer at, but atleast it's something.

Thanks, 
Ivan

> 
> Yours,
> Linus Walleij

