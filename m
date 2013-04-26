Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab3DZIXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:23:49 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33397 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757772Ab3DZIXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:23:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 05/21] atm: he: use mdelay instead of large udelay constants
Date: Fri, 26 Apr 2013 09:21:59 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7203@saturn3.aculab.com>
In-Reply-To: <1366910944-3033663-6-git-send-email-arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 05/21] atm: he: use mdelay instead of large udelay constants
Thread-Index: Ac5B2qQiigc2COPcS8GgHi6CWTWPTgAfAwLg
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-6-git-send-email-arnd@arndb.de>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>, "Chas Williams" <chas@cmf.nrl.navy.mil>,
        <linux-atm-general@lists.sourceforge.net>, <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ARM cannot handle udelay for more than 2 miliseconds, so we
> should use mdelay instead for those.
...
> @@ -1055,7 +1055,7 @@ static int he_start(struct atm_dev *dev)
>  	he_writel(he_dev, 0x0, RESET_CNTL);
>  	he_writel(he_dev, 0xff, RESET_CNTL);
> 
> -	udelay(16*1000);	/* 16 ms */
> +	mdelay(16);	/* 16 ms */
>  	status = he_readl(he_dev, RESET_CNTL);

16ms seems a long time to spin.
I'd have thought a sleep would be more appropriate.
Since this looks like timing a hardware reset pulse
it can't matter if it is somewhat longer.

	David



