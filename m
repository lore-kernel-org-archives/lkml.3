Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaJHJlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:41:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:43314 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015AbaJHJa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:30:27 -0400
Message-ID: <1412760633.13569.4.camel@iivanov-dev>
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for
 register access
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Wed, 08 Oct 2014 12:30:33 +0300
In-Reply-To: <1412759584.13569.0.camel@iivanov-dev>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
	 <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
	 <20141007172606.GG16469@dtor-ws> <1412759584.13569.0.camel@iivanov-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 12:13 +0300, Ivan T. Ivanov wrote:
> On Tue, 2014-10-07 at 10:26 -0700, Dmitry Torokhov wrote:
> > Hi Ivan,
> > 
> > On Tue, Oct 07, 2014 at 12:50:46PM +0300, Ivan T. Ivanov wrote:
> > > @@ -527,10 +538,55 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
> > >  
> 
> > > +
> > > +	kp->row_hold = devm_regmap_field_alloc(kp->dev, kp->regmap,
> > > +					       info->row_hold);
> > > +	if (IS_ERR(kp->row_hold))
> > > +		return PTR_ERR(kp->row_hold);
> > 
> > Why do we have to allocate all regmap fields separately instead of
> > embedding them into keypad structure?
> > 
> 
> No particular reason. Will rework it.
> 

Oops. struct regmap_field is opaque. It seems that the allocation
is the only way that I could have instance of it.

Regards,
Ivan

