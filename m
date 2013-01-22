Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3AVFnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:43:16 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:19289
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab3AVFnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:43:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432I1447Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275eh8275dha1495iz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 22 Jan 2013 14:11:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 13/15] USB: ehci: make orion and mxc bus glues coexist
Message-ID: <20130122061116.GD29677@S2100-06.ap.freescale.net>
References: <Pine.LNX.4.44L0.1301211459550.24224-100000@netrider.rowland.org>
 <201301212137.42611.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201301212137.42611.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 09:37:42PM +0000, Arnd Bergmann wrote:
> > Arnd, please take a look at
> > 
> >         http://marc.info/?l=linux-usb&amp;m=135843716515529&amp;w=2
> > 
> > I can't test it easily, not being set up for cross compilation.  I'm 
> > waiting to hear from anybody whether it works before submitting it.
> > (There's also a report of memory corruption involving a similar patch 
> > for ehci-omap; it hasn't been tracked down yet.)
> 
> Your patch looks good to me, but it also seems to do some other
> changes that are not required to fix the problem but could wait
> for 3.9 instead. You definitely have my Ack if you are willing
> to take it for 3.8 though.
> 
> Shawn or Sascha should be able to test it.
> 
Alan,

Thanks for the patch.  I just gave it try.  The USB Host port still
works for me with a couple of fixes on your changes integrated (one
for compiling and the other for probing).  So you have my ACK with
the changes below rolled into your patch.

Acked-by: Shawn Guo <shawn.guo@linaro.org>

---8<----

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index 177b354..a685945 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -37,7 +37,7 @@

 #define DRIVER_DESC "Freescale On-Chip EHCI Host driver"

-static const char hcd_name[] = "ehci-mxc";
+static const char hcd_name[] = "mxc-ehci";

 #define ULPI_VIEWPORT_OFFSET   0x170

@@ -48,7 +48,7 @@ struct ehci_mxc_priv {
 static struct hc_driver __read_mostly ehci_mxc_hc_driver;

 static const struct ehci_driver_overrides ehci_mxc_overrides __initdata = {
-       .extra_priv_size =      sizeof(struct ehci_mxc_priv);
+       .extra_priv_size =      sizeof(struct ehci_mxc_priv),
 };

 static int ehci_mxc_drv_probe(struct platform_device *pdev)

