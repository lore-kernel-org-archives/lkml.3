Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab3LDOIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:08:20 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27945 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932425Ab3LDOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:08:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z579eh551biz98dI936eI1432I1453I168aJzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 4 Dec 2013 21:38:59 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] usb: chipidea: msm: Use USB PHY API to control PHY
 state
Message-ID: <20131204133858.GC1573@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
 <1384176937-1658-5-git-send-email-iivanov@mm-sol.com>
 <20131111135931.GB21746@shlinux1.ap.freescale.net>
 <1384180569.23605.21.camel@iivanov-dev.int.mm-sol.com>
 <20131204053710.GA29552@shlinux1.ap.freescale.net>
 <1386149754.16040.21.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386149754.16040.21.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 11:35:54AM +0200, Ivan T. Ivanov wrote:
> 
> Hi Peter, 
> 
> On Wed, 2013-12-04 at 13:37 +0800, Peter Chen wrote: 
> > On Mon, Nov 11, 2013 at 04:36:09PM +0200, Ivan T. Ivanov wrote:
> > > 
> > > Hi Peter,
> > > 
> > > On Mon, 2013-11-11 at 21:59 +0800, Peter Chen wrote: 
> > > > On Mon, Nov 11, 2013 at 03:35:37PM +0200, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > > 
> > > > > PHY drivers keep track of the current state of the hardware,
> > > > > so don't change PHY settings under it.
> > > > > 
> > > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > > ---
> > > > >  drivers/usb/chipidea/ci_hdrc_msm.c |    9 ++-------
> > > > >  1 file changed, 2 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> > > > > index e9624f3..338b209 100644
> > > > > --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> > > > > +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> > > > > @@ -20,13 +20,11 @@
> > > > >  static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
> > > > >  {
> > > > >  	struct device *dev = ci->gadget.dev.parent;
> > > > > -	int val;
> > > > >  
> > > > >  	switch (event) {
> > > > >  	case CI_HDRC_CONTROLLER_RESET_EVENT:
> > > > >  		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
> > > > > -		writel(0, USB_AHBBURST);
> > > > > -		writel(0, USB_AHBMODE);
> > > > > +		usb_phy_init(ci->transceiver);
> > > > 
> > > > It will reset the PHY,  but your comment is "don't change PHY settings under it"
> > > 
> > > :-). This function is exported by PHY drivers, so they will know how
> > > to handle this change.
> > > 
> > > > 
> > > > >  		break;
> > > > >  	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
> > > > >  		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
> > > > > @@ -34,10 +32,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
> > > > >  		 * Put the transceiver in non-driving mode. Otherwise host
> > > > >  		 * may not detect soft-disconnection.
> > > > >  		 */
> > > > > -		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
> > > > > -		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
> > > > > -		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
> > > > > -		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
> > > > > +		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
> > > > 
> > > > Where you have implemented .notify_disconnect?
> > > > I have not found it at your phy driver.
> > > 
> > > Yep, I will post PHY driver changes shortly. Meanwhile this should
> > > not break existing board file based platforms, because not of them
> > > could be compiled (HTC Dream, Halibut Board) and DT based platforms 
> > > are sill work in progress.
> > > 
> > 
> > Hi Ivan, I am going to apply this msm chipidea patchset, but the change
> > in this file is different with its original meaning. 
> 
> What did you mean?
> 
> CI_HDRC_CONTROLLER_RESET_EVENT -> usb_phy_init()
> Take wherever actions are needed to put device in known state. ?

At current code, it only sets two AHB parameters which should be only related
to controller but your patch init the whole PHY, look at msm_otg_reset,
it does many other things, like phy reset, controller reset, etc.

Does the partial otg fsm at msm_otg_sm_work will be called or not? If it is
not called, then, it is OK you just use msm_otg_reset here.

> 
> CI_HDRC_CONTROLLER_STOPPED_EVENT -> usb_phy_notify_disconnect() 
> Emitted after ci->driver->disconnect(&ci->gadget);

I just see your [PATCH v4 14/15] usb: phy: msm: Handle disconnect events,
then, it is ok now. By the way, do I need to wait your phy patches are queued,
otherwise, it may not work?

> 
> Probably I am missing something.
> 
> 
> > Have you
> > tested at existing platforms?
> 
> 
> I have 8074 based DragonBoard which I used for testing. 
> CV Test Suite engine "Chapter 9 tests" are passing except
> "Halt Endpoint Test". 

I mean with your patch, the old non-dt platform can work or not?

-- 

Best Regards,
Peter Chen

