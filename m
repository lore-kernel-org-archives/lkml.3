Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAJOtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:49:23 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58785 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaAJOtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:49:19 -0500
Date: Fri, 10 Jan 2014 15:49:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140110144917.GA12048@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140103013640.GB27678@earth.universe>
 <20140109233843.GB19974@amd.pavel.ucw.cz>
 <20140110003231.GA14141@earth.universe>
 <20140110121805.GA21117@amd.pavel.ucw.cz>
 <20140110134426.GA7235@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110134426.GA7235@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> You have missed some things. See inline comments below.

Ok, I've done this, it should fix the rest.

diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index d6e9b3911..6615939 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -1138,8 +1138,8 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	info->uart_iclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_iclk);
 	info->uart_fclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
 
-	err = request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED, "hci_h4p",
-			  info);
+	err = devm_request_irq(&pdev->dev, info->irq, hci_h4p_interrupt, IRQF_DISABLED,
+			       "hci_h4p", info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq);
 		return err;
@@ -1192,9 +1192,6 @@ static int hci_h4p_remove(struct platform_device *pdev)
 	hci_h4p_hci_close(info->hdev);
 	hci_unregister_dev(info->hdev);
 	hci_free_dev(info->hdev);
-	gpio_free(info->bt_wakeup_gpio);
-	gpio_free(info->host_wakeup_gpio);
-	free_irq(info->irq, (void *) info);
 
 	return 0;
 }



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
