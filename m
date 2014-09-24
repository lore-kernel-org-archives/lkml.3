Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaIXIbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:31:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62150 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaIXIbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:31:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: balbi@ti.com, Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, sebastian.hesselbarth@gmail.com,
        p.zabel@pengutronix.de, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Wed, 24 Sep 2014 10:30:41 +0200
Message-ID: <2923729.dtX0WmHSV0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2990737.4KzKXPZhaB@wuerfel>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <20140924022736.GA5307@peterchendt> <2990737.4KzKXPZhaB@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZIKU4AuMLkY3T2OXsfDhBPMgAeVNhKvZcH7r/Rl7U1L
 IKTJ5iqTHVoDiJedRMiYSfrCfENbvy1efSN9xBkCTgxS/W0Z45
 tqnoIvfJD2maqD5gYAU0nzP6BX/eAS8ENkdXOBxvYEn++/7Ozy
 1rjUAqbIZQg2MQKKv6zvI+8VarC1aDH3cgJKQb91sXs3oWFBIE
 8GiT/rWXaM+NU+rgtEUe26ykrketcuysKQl5UiTu7GZ8N3V8WF
 7LJtXWTRjwtnW72d4U0BSAb2oIF21tYXuU2dFJQf1xLxitBKBN
 Mbc3XgY0OpLua9cot0sumrTfePcn4PpzNgHJfliHkyP2mwy2h3
 uDHZR4/Ntpk7kQa8ATzU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014 09:44:19 Arnd Bergmann wrote:
> 
> We can also gradually move in some of the other glue drivers into
> the main driver if the differences are small enough.
> 

FWIW, I've just looked at the other glue drivers that already
exist:

- zevio can just get merged into the common driver, all that seems
  to be needed for that is the additional compatible string, and
  keying off the ci_default_zevio_platdata on the .data field of
  the of_device_id table.

- msm has a custom notifier, which justifies leaving it in a separate
  driver, but it's also small enough that it wouldn't hurt to have
  that merged into the main driver too.

- imx requires a lot of other things, in particular the dependency
  on the usbmisc driver means we don't want to have that in the
  core anyway, so we can't really merge that in.

- the proposed ar933x driver again looks almost trivial, so no reason
  for a separate glue driver for that.

	Arnd
