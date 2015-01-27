Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbbA0Roh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:44:37 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4667 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbbA0Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:44:35 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Tue, 27 Jan 2015 09:44:31 -0800
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: qcom: enable generic support and input-enable
 pinctrl conf
Message-ID: <20150127174430.GF11960@sonymobile.com>
References: <1422289494-31461-1-git-send-email-svarbanov@mm-sol.com>
 <54C6E753.606@codeaurora.org>
 <54C6E89E.2050701@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54C6E89E.2050701@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26 Jan 17:23 PST 2015, Stephen Boyd wrote:

> On 01/26/15 17:18, Stephen Boyd wrote:
> > On 01/26/15 08:24, Stanimir Varbanov wrote:
> >
> >>  		return -ENOTSUPP;
> >>  	}
> >>  
> >> @@ -208,14 +208,12 @@ static int msm_config_get(struct pinctrl_dev *pctldev,
> >>  			  unsigned int pin,
> >>  			  unsigned long *config)
> >>  {
> >> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> > Same for here.
> >
> >>  	return -ENOTSUPP;
> >>  }
> >>  
> >>  static int msm_config_set(struct pinctrl_dev *pctldev, unsigned int pin,
> >>  				unsigned long *configs, unsigned num_configs)
> >>  {
> >> -	dev_err(pctldev->dev, "pin_config_set op not supported\n");
> > And here.
> 
> Actually it looks like we can just remove these two functions and the
> core does the right thing and prints errors. That would be a good patch.
> 

Yeah, seems c420619d51 ("pinctrl: pinconf: remove checks on
ops->pin_config_get") introduced in 3.14 reduced the requirements here.

Seems like there is a whole bunch of drivers that would benefit from this
cleanup still.

Regards,
Bjorn
