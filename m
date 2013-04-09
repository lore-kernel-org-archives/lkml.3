Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935706Ab3DIJDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:03:52 -0400
Received: from sauhun.de ([89.238.76.85]:34811 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934875Ab3DIJDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:03:51 -0400
Date: Tue, 9 Apr 2013 11:03:49 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: Re: [3/7] i2c-designware-pci: use managed functions pcim_* and devm_*
Message-ID: <20130409090348.GB28509@the-dreams.de>
References: <1363867800-23861-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363867800-23861-3-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -296,10 +273,11 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
>  	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
>  		adap->nr);
>  
> -	r = request_irq(pdev->irq, i2c_dw_isr, IRQF_SHARED, adap->name, dev);
> +	r = devm_request_irq(&pdev->dev, pdev->irq, i2c_dw_isr, IRQF_SHARED,
> +			adap->name, dev);

IRQ question from patch 1 fits here, too.

