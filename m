Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaBSObb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:31:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaBSOba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:31:30 -0500
Date: Wed, 19 Feb 2014 06:34:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: santosh.shilimkar@ti.com, rob@landley.net, linux@arm.linux.org.uk,
        galak@kernel.crashing.org, devicetree@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, rob.herring@calxeda.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, grygorii.strashko@ti.com,
        dwmw2@infradead.org, nsekhar@ti.com,
        "[initial author] Murali Karicheri" <m-karicheri2@ti.com>
Subject: Re: [PATCH v4 1/2] memory: ti-aemif: introduce AEMIF driver
Message-ID: <20140219143403.GA31063@kroah.com>
References: <1391629574-18955-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1391629574-18955-2-git-send-email-ivan.khoronzhuk@ti.com>
 <20140218203049.GA18647@kroah.com>
 <53048822.2080307@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53048822.2080307@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 12:32:02PM +0200, Ivan Khoronzhuk wrote:
> >> +	aemif->clk = devm_clk_get(dev, NULL);
> >> +	if (IS_ERR(aemif->clk)) {
> >> +		dev_err(dev, "cannot get clock 'aemif'\n");
> >> +		return PTR_ERR(aemif->clk);
> > No freeing memory?
> 
> There is no need to free memory explicitly.
> devm_kzalloc is used instead of kzalloc.

Yes, but where does the device on the error path get removed?
