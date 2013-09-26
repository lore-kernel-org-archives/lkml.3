Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3IZQwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:52:10 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:25700 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3IZQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:52:05 -0400
X-AuditID: cbfec373-b7f6d6d00000330d-59-52446634b5f1
Date: Thu, 26 Sep 2013 13:51:57 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Christian Volkmann <cv@cv-sv.de>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Koch <johannes@ortsraum.de>
Subject: Re: [PATCH 1/1] cx23885-dvb: fix ds3000 ts2020 split for TEVII S471
Message-id: <20130926135157.2a26f245@samsung.com>
In-reply-to: <1376513927-6217-1-git-send-email-cv@cv-sv.de>
References: <1376513927-6217-1-git-send-email-cv@cv-sv.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/hEF2TNJcgg8WrBCye3ljMZnFr92oW
	i6unNzNbnHn3h9Hi8q45bBY9G7ayWqx4dJPZ4vnjE+wOHB7brk9n99g56y67x9xjvYwe06fJ
	eEx9f4jV49vdd6wenzfJBbBHcdmkpOZklqUW6dslcGVMWP2YqeCgRMWBhj9sDYy9Il2MnBwS
	AiYS02/sZYKwxSQu3FvP1sXIxSEksIRR4ueih8wQTg+TxKGmNcwgVSwCqhK3Vq5lBbHZBIwk
	XjW2ANkcHCICKhI7TzqB1DMLzGSSuHH+ESNIXFjAR2L3QU4Qk1fAUOLLpGCQTk4Ba4nV2z6A
	TRQSsJI4cmEhM0iJhICTxNapviBhXgFBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWewCgwC0nZ
	LCRls5CULWBkXsUoWlqcXFCclJ5rpFecmFtcmpeul5yfu4kREvzFOxhfbLA6xCjAwajEw6vJ
	5hwkxJpYVlyZe4hRgoNZSYR3faxLkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGhW0+C05NW17G
	PCF+Q0zks9daWgcv7tt38N3ezHufPq+enJuy0Fv9pOoTZsmO3vaPXWLCkUJtqUy+nTOVVjrb
	cu2I9ZrtNN25/0/kokMsjsHCnqtNNy5POvg1rO3vs5nHZbrnyjbParvOIMlkrh66eHNRfmJf
	0M6VH78vm/JYp9vgJYP+h9bXSizFGYmGWsxFxYkAUG9kV1wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Em Wed, 14 Aug 2013 22:58:47 +0200
Christian Volkmann <cv@cv-sv.de> escreveu:

> A split for ds3000/ts2020 code forgot to change the TEVII_S471 code.
> Change the TEVII_S471 according the changes to TEVII_S470.
> 
> Signed-off-by: Christian Volkmann <cv@cv-sv.de>
> ---
>  drivers/media/pci/cx23885/cx23885-dvb.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 9c5ed10..be98c49 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1038,7 +1038,6 @@ static int dvb_register(struct cx23885_tsport *port)
>  				&tevii_ts2020_config, &i2c_bus->i2c_adap);
>  			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
>  		}
> -
>  		break;
>  	case CX23885_BOARD_DVBWORLD_2005:
>  		i2c_bus = &dev->i2c_bus[1];
> @@ -1249,6 +1248,11 @@ static int dvb_register(struct cx23885_tsport *port)
>  		fe0->dvb.frontend = dvb_attach(ds3000_attach,
>  					&tevii_ds3000_config,
>  					&i2c_bus->i2c_adap);
> +		if (fe0->dvb.frontend != NULL) {
> +			dvb_attach(ts2020_attach, fe0->dvb.frontend,
> +				&tevii_ts2020_config, &i2c_bus->i2c_adap);
> +			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
> +		}
>  		break;
>  	case CX23885_BOARD_PROF_8000:
>  		i2c_bus = &dev->i2c_bus[0];


A similar patch got applied already, sent by Johannes:

commit b43ea8068d2090cb1e44632c8a938ab40d2c7419
Author: Johannes Koch <johannes@ortsraum.de>
Date:   Wed Jul 17 14:28:16 2013 -0300

    [media] cx23885: Fix TeVii S471 regression since introduction of ts2020
    
    Patch to make TeVii S471 cards use the ts2020 tuner, since ds3000 driver no
    longer contains tuning code.
    
    Signed-off-by: Johannes Koch <johannes@ortsraum.de>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

The difference between your patch and the applied one is:

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 971e4ff..8ed7b94 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1055,7 +1055,6 @@ static int dvb_register(struct cx23885_tsport *port)
 				&tevii_ts2020_config, &i2c_bus->i2c_adap);
 			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
 		}
-
 		break;
 	case CX23885_BOARD_DVBWORLD_2005:
 		i2c_bus = &dev->i2c_bus[1];
@@ -1285,6 +1284,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		if (fe0->dvb.frontend != NULL) {
 			dvb_attach(ts2020_attach, fe0->dvb.frontend,
 				&tevii_ts2020_config, &i2c_bus->i2c_adap);
+			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
 		}
 		break;
 	case CX23885_BOARD_PROF_8000:


So, basically, on our patch, you're also filling ops.set_voltage. 

As I don't know the board details, I can't tell if this is required or
not.

Christian/Johannes,

Could you please double-check it? If this is needed, please send me a new
patch, rebased on the top of linux-media git tree.

Thanks!
Mauro
