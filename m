Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3C2LRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:17:17 -0400
Received: from sauhun.de ([89.238.76.85]:33915 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3C2LRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:17:15 -0400
Date: Fri, 29 Mar 2013 12:17:09 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, nsekhar@ti.com,
        khilman@deeprootsystems.com, ben-linux@fluff.org,
        w.sang@pengutronix.de
Subject: Re: [PATCH V4] i2c: davinci: update to devm_* API
Message-ID: <20130329111709.GA6359@the-dreams.de>
References: <1362483885-16561-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362483885-16561-1-git-send-email-manishv.b@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 05:14:45PM +0530, Vishwanathrao Badarkhe, Manish wrote:
> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

Applied the following fix:

> +	dev->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(dev->base)) {
> +		r = PTR_ERR(dev->base);
> +		dev_err(&pdev->dev, "I2C region already claimed\n");
> +		goto err_unuse_clocks;

No dev_err after devm_ioremap_resource. make coccicheck will tell you
about this.

Otherwise: Applied to for-next, thanks!

