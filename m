Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3FKOXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:23:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:15734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3FKOXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="327707395"
Date: Tue, 11 Jun 2013 16:23:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 01/22] mfd/ti_am335x_tscadc: remove regmap
Message-ID: <20130611142336.GE29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <1370950268-7224-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370950268-7224-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Jun 11, 2013 at 01:30:47PM +0200, Sebastian Andrzej Siewior wrote:
> The MFD part uses regmap without caching and is the only user of the
> regmap. The child drivers, that is input(touch) and iio(adc), use direct
> reg access.
> There is a patch which converts them to use regmap as well but I see no
> benefit at all doing this. There is a direct MMIO bus access with no
> need to cache values like for I2C or SPI devices. Furthermore, most (if
> not all) of the access done by the touch & ADC driver read volatile
> register.
> Therefore this patch removes regmap part of the driver.
NAK. Using regmap is better than open coding your register accesses, and
the children not using this API is not a reason for the MFD driver to do
the same.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
