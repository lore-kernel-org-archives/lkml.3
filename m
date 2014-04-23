Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaDWGwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:52:07 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33749 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbaDWGwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:52:04 -0400
Message-ID: <1398235867.4724.182.camel@iivanov-dev>
Subject: Re: [PATCH v6 06/19] usb: phy: msm: Fix checkpatch.pl warnings
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 23 Apr 2014 09:51:07 +0300
In-Reply-To: <53568B0C.3080107@linaro.org>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-7-git-send-email-iivanov@mm-sol.com>
	 <53568B0C.3080107@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-04-22 at 16:30 +0100, Srinivas Kandagatla wrote:
> 
> On 22/04/14 10:20, Ivan T. Ivanov wrote:
> > @@ -79,8 +78,7 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
> >   		ret = regulator_set_voltage(motg->vddcx, 0,
> >   			USB_PHY_VDD_DIG_VOL_MAX);
> >   		if (ret)
> > -			dev_err(motg->phy.dev, "unable to set the voltage "
> > -					"for hsusb vddcx\n");
> > +			dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
> 
> 
> > @@ -137,15 +133,13 @@ static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
> >   		ret = regulator_set_optimum_mode(motg->v1p8,
> >   				USB_PHY_1P8_HPM_LOAD);
> >   		if (ret < 0) {
> > -			pr_err("%s: Unable to set HPM of the regulator "
> > -				"HSUSB_1p8\n", __func__);
> > +			pr_err("Could not set HPM for v1p8\n");
> >   			return ret;
> >   		}
> 
> 
> > @@ -390,8 +382,7 @@ static int msm_hsusb_config_vddcx(struct msm_otg *motg, int high)
> >
> >   	ret = regulator_set_voltage(motg->vddcx, min_vol, max_vol);
> >   	if (ret) {
> > -		pr_err("%s: unable to set the voltage for regulator "
> > -			"HSUSB_VDDCX\n", __func__);
> > +		dev_err(motg->phy.dev, "Cannot set vddcx voltage\n");
> >   		return ret;
> >   	}
> >
> 
> 
> I see some of pr_err not moved to dev_err?, while others have been moved.

Right, intention was to just shorten messages to fit one line, to make 
checkpatch.pl happy.

Thanks, 
Ivan

> Also noticed that the error messages are changed as part of this fix. 
> IMHO, changing an error message would have a side-effects on logging 
> tools, anyway Am not sure if its true in this case.
> 
> Thanks,
> srini
> --

