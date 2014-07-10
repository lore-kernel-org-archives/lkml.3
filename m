Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaGJMip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:38:45 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50740 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaGJMin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:38:43 -0400
Date: Thu, 10 Jul 2014 14:38:37 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/16] i2c: drop class based instantiaion for selected
 drivers
Message-ID: <20140710143837.558c1d07@ipc1.ka-ro>
In-Reply-To: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
References: <1404992799-3705-1-git-send-email-wsa@the-dreams.de>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wolfram Sang wrote:
> Some drivers were flagged to remove class based instantiation soon to improve
> boot-up time. Originally, I was planning for a longer deprecation time so users
> could switch over to some other kind of instantiation. However, the demand for
> the speed up is high enough and class based instantiation is used rarely, so
> the removal takes place now. To make up for the deprecation time, another
> warning is added to the i2c core pointing out that the behaviour has now
> changed:
> 
> +	/* Warn that the adapter lost class based instantiation */
> +	if (adapter->class == I2C_CLASS_DEPRECATED) {
> +		dev_dbg(&adapter->dev,
> +			"This adapter dropped support for I2C classes and "
> +			"won't auto-detect %s devices anymore. If you need it, check "
> +			"'Documentation/i2c/instantiating-devices' for alternatives.\n",
>
It's usually a bad idea to split kernel messages across source lines
because it makes searching for the corresponding source line for a
message found in the log difficult.
You could at least do the split at the sentence boundary.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
