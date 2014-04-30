Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbaD3PeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:34:04 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13305 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758924AbaD3PeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:34:01 -0400
Message-ID: <1398872038.24255.41.camel@hornet>
Subject: Re: [PATCH 10/10] hwmon: vexpress: Use devm helper for hwmon device
 registration
From: Pawel Moll <pawel.moll@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Jean Delvare <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Wed, 30 Apr 2014 16:33:58 +0100
In-Reply-To: <20140430152754.GA30924@roeck-us.net>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
	 <1398707877-22596-11-git-send-email-pawel.moll@arm.com>
	 <535EDD49.8050107@roeck-us.net> <1398870979.24255.37.camel@hornet>
	 <20140430152754.GA30924@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 16:27 +0100, Guenter Roeck wrote:
> > I'm not sure I understand the question. The other patch from the series
> 
> The code above seems to change from
> 
>    	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
> 	if (!data->reg)
> 		return -ENODEV;
> 
> to
> 
>    	data->reg = devm_regmap_init_vexpress_config(&pdev->dev);
> 	if (IS_ERR(data->reg))
> 		return PTR_ERR(data->reg);
> 
> as part of this patch. This suggests that the return value from
> devm_regmap_init_vexpress_config may have changed from NULL to 
> ERR_PTR. Is my understanding wrong ?

No, you've got it right, but it's me making a mistake in patch splitting
- it is supposed to be a part of the first patch. Thanks for spotting
this!

Pawel

