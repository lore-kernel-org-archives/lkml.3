Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaJaNsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:48:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56778 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119AbaJaNsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:48:36 -0400
Date: Fri, 31 Oct 2014 08:47:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Chen <peter.chen@freescale.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141031134751.GE1273@saruman>
Reply-To: <balbi@ti.com>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
 <20141030163513.GI10130@saruman>
 <20141030174254.GA6764@kwain>
 <20141030174734.GA6652@saruman>
 <20141031003812.GA3692@peterchendt>
 <20141031004710.GA17652@saruman>
 <20141031133319.GC1273@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7U+bLA8boMOj+mD"
Content-Disposition: inline
In-Reply-To: <20141031133319.GC1273@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--r7U+bLA8boMOj+mD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 08:33:19AM -0500, Felipe Balbi wrote:
> > > > > > > > Before using the PHY framework instead of the USB PHY one, =
we need to
> > > > > > > > move the OTG state into another place, since it won't be av=
ailable when
> > > > > > > > USB PHY isn't used. This patch moves the OTG state into the=
 OTG
> > > > > > > > structure, and makes all the needed modifications in the dr=
ivers
> > > > > > > > using the OTG state.
> > > > > > > >=20
> > > > > > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electron=
s.com>
> > > > > > > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > > > > > >=20
> > > > > > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > > > >=20
> > > > > > Please rebase on my testing/next and I'll take the series. When
> > > > > > rebasing, then add Peter's Tested-by/Acked-by where they're mis=
sing.
> > > > >=20
> > > > > I just re-sent the series, rebased on your testing/next branch.
> > > >=20
> > > > Thanks, I put them on my testing/next and I'm running build tests.
> > > >=20
> > >=20
> > > I see them, I will rebase your testing/next tree for coming chipidea =
dev, thanks.
> >=20
> > I fixed a build breakage caused by $subject which I fixed, updated patch
> > below: (Aaro, can I get a tested-by by any chance ?)
>=20
> two more build regressions found (did you build test your patches ??)

and yet another one on phy-isp1301-omap.c. Seriously, if I find another
build regression I'll drop your series from my queue and defer it to
3.20. This is ridiculous already.

8<------------------------------------------------------------------------

commit 5fd2f70ddea9102019cc9686d2b1eb88405ce235
Author: Antoine Tenart <antoine.tenart@free-electrons.com>
Date:   Thu Oct 30 18:41:13 2014 +0100

    usb: move the OTG state from the USB PHY to the OTG structure
   =20
    Before using the PHY framework instead of the USB PHY one, we need to
    move the OTG state into another place, since it won't be available when
    USB PHY isn't used. This patch moves the OTG state into the OTG
    structure, and makes all the needed modifications in the drivers
    using the OTG state.
   =20
    [ balbi@ti.com : fix build regressions with phy-tahvo.c, musb_dsps.c,
    		phy-isp1301-omap, and chipidea's debug.c ]
   =20
    Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
    Acked-by: Peter Chen <peter.chen@freescale.com>
    Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 8c84298..9f409359 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -80,11 +80,9 @@ static int omap_usb_start_srp(struct usb_otg *otg)
=20
 static int omap_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct usb_phy	*phy =3D otg->phy;
-
 	otg->host =3D host;
 	if (!host)
-		phy->state =3D OTG_STATE_UNDEFINED;
+		otg->state =3D OTG_STATE_UNDEFINED;
=20
 	return 0;
 }
@@ -92,11 +90,9 @@ static int omap_usb_set_host(struct usb_otg *otg, struct=
 usb_bus *host)
 static int omap_usb_set_peripheral(struct usb_otg *otg,
 		struct usb_gadget *gadget)
 {
-	struct usb_phy	*phy =3D otg->phy;
-
 	otg->gadget =3D gadget;
 	if (!gadget)
-		phy->state =3D OTG_STATE_UNDEFINED;
+		otg->state =3D OTG_STATE_UNDEFINED;
=20
 	return 0;
 }
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index 795d653..f038804 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -220,7 +220,7 @@ static int ci_otg_show(struct seq_file *s, void *unused)
=20
 	/* ------ State ----- */
 	seq_printf(s, "OTG state: %s\n\n",
-		usb_otg_state_string(ci->transceiver->state));
+		usb_otg_state_string(ci->transceiver->otg->state));
=20
 	/* ------ State Machine Variables ----- */
 	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index caaabc5..8cb2508 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -328,7 +328,7 @@ static void b_ssend_srp_tmout_func(void *ptr, unsigned =
long indicator)
 	set_tmout(ci, indicator);
=20
 	/* only vbus fall below B_sess_vld in b_idle state */
-	if (ci->transceiver->state =3D=3D OTG_STATE_B_IDLE)
+	if (ci->fsm.otg->state =3D=3D OTG_STATE_B_IDLE)
 		ci_otg_queue_work(ci);
 }
=20
@@ -582,11 +582,11 @@ int ci_otg_fsm_work(struct ci_hdrc *ci)
 	 * when there is no gadget class driver
 	 */
 	if (ci->fsm.id && !(ci->driver) &&
-		ci->transceiver->state < OTG_STATE_A_IDLE)
+		ci->fsm.otg->state < OTG_STATE_A_IDLE)
 		return 0;
=20
 	if (otg_statemachine(&ci->fsm)) {
-		if (ci->transceiver->state =3D=3D OTG_STATE_A_IDLE) {
+		if (ci->fsm.otg->state =3D=3D OTG_STATE_A_IDLE) {
 			/*
 			 * Further state change for cases:
 			 * a_idle to b_idle; or
@@ -600,7 +600,7 @@ int ci_otg_fsm_work(struct ci_hdrc *ci)
 				ci_otg_queue_work(ci);
 			if (ci->id_event)
 				ci->id_event =3D false;
-		} else if (ci->transceiver->state =3D=3D OTG_STATE_B_IDLE) {
+		} else if (ci->fsm.otg->state =3D=3D OTG_STATE_B_IDLE) {
 			if (ci->fsm.b_sess_vld) {
 				ci->fsm.power_up =3D 0;
 				/*
@@ -627,7 +627,7 @@ static void ci_otg_fsm_event(struct ci_hdrc *ci)
 	otg_bsess_vld =3D hw_read_otgsc(ci, OTGSC_BSV);
 	port_conn =3D hw_read(ci, OP_PORTSC, PORTSC_CCS);
=20
-	switch (ci->transceiver->state) {
+	switch (ci->fsm.otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
 		if (port_conn) {
 			fsm->b_conn =3D 1;
@@ -794,7 +794,7 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
 	ci->transceiver->otg =3D ci->fsm.otg;
 	ci->fsm.power_up =3D 1;
 	ci->fsm.id =3D hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
-	ci->transceiver->state =3D OTG_STATE_UNDEFINED;
+	ci->fsm.otg->state =3D OTG_STATE_UNDEFINED;
 	ci->fsm.ops =3D &ci_otg_ops;
=20
 	mutex_init(&ci->fsm.lock);
diff --git a/drivers/usb/common/usb-otg-fsm.c b/drivers/usb/common/usb-otg-=
fsm.c
index 98e8340..c6b35b7 100644
--- a/drivers/usb/common/usb-otg-fsm.c
+++ b/drivers/usb/common/usb-otg-fsm.c
@@ -124,10 +124,10 @@ static void otg_leave_state(struct otg_fsm *fsm, enum=
 usb_otg_state old_state)
 static int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 {
 	state_changed =3D 1;
-	if (fsm->otg->phy->state =3D=3D new_state)
+	if (fsm->otg->state =3D=3D new_state)
 		return 0;
 	VDBG("Set state: %s\n", usb_otg_state_string(new_state));
-	otg_leave_state(fsm, fsm->otg->phy->state);
+	otg_leave_state(fsm, fsm->otg->state);
 	switch (new_state) {
 	case OTG_STATE_B_IDLE:
 		otg_drv_vbus(fsm, 0);
@@ -236,7 +236,7 @@ static int otg_set_state(struct otg_fsm *fsm, enum usb_=
otg_state new_state)
 		break;
 	}
=20
-	fsm->otg->phy->state =3D new_state;
+	fsm->otg->state =3D new_state;
 	return 0;
 }
=20
@@ -247,7 +247,7 @@ int otg_statemachine(struct otg_fsm *fsm)
=20
 	mutex_lock(&fsm->lock);
=20
-	state =3D fsm->otg->phy->state;
+	state =3D fsm->otg->state;
 	state_changed =3D 0;
 	/* State machine state change judgement */
=20
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index 0231606d..cf89b4b1 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -183,7 +183,7 @@ static void start_hnp(struct ohci_hcd *ohci)
 	otg_start_hnp(hcd->usb_phy->otg);
=20
 	local_irq_save(flags);
-	hcd->usb_phy->state =3D OTG_STATE_A_SUSPEND;
+	hcd->usb_phy->otg.state =3D OTG_STATE_A_SUSPEND;
 	writel (RH_PS_PSS, &ohci->regs->roothub.portstatus [port]);
 	l =3D omap_readl(OTG_CTRL);
 	l &=3D ~OTG_A_BUSREQ;
diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index a2735df..d836a3e 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -149,25 +149,25 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl =3D musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "Poll devctl %02x (%s)\n", devctl,
-		usb_otg_state_string(musb->xceiv->state));
+		usb_otg_state_string(musb->xceiv->otg->state));
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
 		devctl &=3D ~MUSB_DEVCTL_SESSION;
 		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
=20
 		devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
 	case OTG_STATE_A_WAIT_VFALL:
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, CORE_INTR_SRC_SET_REG,
 			    MUSB_INTR_VBUSERROR << AM35X_INTR_USB_SHIFT);
 		break;
@@ -176,7 +176,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -193,9 +193,9 @@ static void am35x_musb_try_idle(struct musb *musb, unsi=
gned long timeout)
=20
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || (musb->a_wait_bcon =3D=3D 0 &&
-				musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
+				musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		del_timer(&otg_workaround);
 		last_timer =3D jiffies;
 		return;
@@ -208,7 +208,7 @@ static void am35x_musb_try_idle(struct musb *musb, unsi=
gned long timeout)
 	last_timer =3D timeout;
=20
 	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&otg_workaround, timeout);
 }
@@ -278,27 +278,27 @@ static irqreturn_t am35x_musb_interrupt(int irq, void=
 *hci)
 			 * devctl.
 			 */
 			musb->int_usb &=3D ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (drvvbus) {
 			MUSB_HST_MODE(musb);
 			otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |=3D USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active =3D 0;
 			MUSB_DEV_MODE(musb);
 			otg->default_a =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			portstate(musb->port1_status &=3D ~USB_PORT_STAT_POWER);
 		}
=20
 		/* NOTE: this must complete power-on within 100 ms. */
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				err ? " ERROR" : "",
 				devctl);
 		ret =3D IRQ_HANDLED;
@@ -324,7 +324,7 @@ eoi:
 	}
=20
 	/* Poll for ID change */
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE)
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 8554c6f..f23ce40b 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -185,8 +185,8 @@ static irqreturn_t blackfin_interrupt(int irq, void *__=
hci)
 	}
=20
 	/* Start sampling ID pin, when plug is removed from MUSB */
-	if ((musb->xceiv->state =3D=3D OTG_STATE_B_IDLE
-		|| musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON) ||
+	if ((musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE
+		|| musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON) ||
 		(musb->int_usb & MUSB_INTR_DISCONNECT && is_host_active(musb))) {
 		mod_timer(&musb_conn_timer, jiffies + TIMER_DELAY);
 		musb->a_wait_bcon =3D TIMER_DELAY;
@@ -205,7 +205,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
 	static u8 toggle;
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_IDLE:
 	case OTG_STATE_A_WAIT_BCON:
 		/* Start a new session */
@@ -219,7 +219,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
=20
 		if (!(val & MUSB_DEVCTL_BDEVICE)) {
 			gpio_set_value(musb->config->gpio_vrsel, 1);
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 		} else {
 			gpio_set_value(musb->config->gpio_vrsel, 0);
 			/* Ignore VBUSERROR and SUSPEND IRQ */
@@ -229,7 +229,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
=20
 			val =3D MUSB_INTR_SUSPEND | MUSB_INTR_VBUSERROR;
 			musb_writeb(musb->mregs, MUSB_INTRUSB, val);
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		}
 		mod_timer(&musb_conn_timer, jiffies + TIMER_DELAY);
 		break;
@@ -245,7 +245,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
=20
 		if (!(val & MUSB_DEVCTL_BDEVICE)) {
 			gpio_set_value(musb->config->gpio_vrsel, 1);
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 		} else {
 			gpio_set_value(musb->config->gpio_vrsel, 0);
=20
@@ -280,13 +280,13 @@ static void musb_conn_timer_handler(unsigned long _mu=
sb)
 		break;
 	default:
 		dev_dbg(musb->controller, "%s state not handled\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		break;
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
=20
 	dev_dbg(musb->controller, "state is %s\n",
-		usb_otg_state_string(musb->xceiv->state));
+		usb_otg_state_string(musb->xceiv->otg->state));
 }
=20
 static void bfin_musb_enable(struct musb *musb)
@@ -307,7 +307,7 @@ static void bfin_musb_set_vbus(struct musb *musb, int i=
s_on)
=20
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x "
 		/* otg %3x conf %08x prcm %08x */ "\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
=20
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 058775e..527c7fe 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -198,20 +198,20 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl =3D musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "Poll devctl %02x (%s)\n", devctl,
-		usb_otg_state_string(musb->xceiv->state));
+		usb_otg_state_string(musb->xceiv->otg->state));
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
 		devctl &=3D ~MUSB_DEVCTL_SESSION;
 		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
=20
 		devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
@@ -226,7 +226,7 @@ static void otg_timer(unsigned long _musb)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			break;
 		}
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, DA8XX_USB_INTR_SRC_SET_REG,
 			    MUSB_INTR_VBUSERROR << DA8XX_INTR_USB_SHIFT);
 		break;
@@ -248,7 +248,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -265,9 +265,9 @@ static void da8xx_musb_try_idle(struct musb *musb, unsi=
gned long timeout)
=20
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || (musb->a_wait_bcon =3D=3D 0 &&
-				musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
+				musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		del_timer(&otg_workaround);
 		last_timer =3D jiffies;
 		return;
@@ -280,7 +280,7 @@ static void da8xx_musb_try_idle(struct musb *musb, unsi=
gned long timeout)
 	last_timer =3D timeout;
=20
 	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&otg_workaround, timeout);
 }
@@ -341,26 +341,26 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void=
 *hci)
 			 * devctl.
 			 */
 			musb->int_usb &=3D ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (drvvbus) {
 			MUSB_HST_MODE(musb);
 			otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |=3D USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active =3D 0;
 			MUSB_DEV_MODE(musb);
 			otg->default_a =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			portstate(musb->port1_status &=3D ~USB_PORT_STAT_POWER);
 		}
=20
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				err ? " ERROR" : "",
 				devctl);
 		ret =3D IRQ_HANDLED;
@@ -375,7 +375,7 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *=
hci)
 		musb_writel(reg_base, DA8XX_USB_END_OF_INTR_REG, 0);
=20
 	/* Poll for ID change */
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE)
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index 04de3ac..3c1d9b2 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -214,10 +214,10 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl =3D musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "poll devctl %02x (%s)\n", devctl,
-		usb_otg_state_string(musb->xceiv->state));
+		usb_otg_state_string(musb->xceiv->otg->state));
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_VFALL:
 		/* Wait till VBUS falls below SessionEnd (~0.2V); the 1.3 RTL
 		 * seems to mis-handle session "start" otherwise (or in our
@@ -228,7 +228,7 @@ static void otg_timer(unsigned long _musb)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			break;
 		}
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, DAVINCI_USB_INT_SET_REG,
 			MUSB_INTR_VBUSERROR << DAVINCI_USB_USBINT_SHIFT);
 		break;
@@ -251,7 +251,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -325,20 +325,20 @@ static irqreturn_t davinci_musb_interrupt(int irq, vo=
id *__hci)
 			 * to stop registering in devctl.
 			 */
 			musb->int_usb &=3D ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (drvvbus) {
 			MUSB_HST_MODE(musb);
 			otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |=3D USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active =3D 0;
 			MUSB_DEV_MODE(musb);
 			otg->default_a =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			portstate(musb->port1_status &=3D ~USB_PORT_STAT_POWER);
 		}
=20
@@ -348,7 +348,7 @@ static irqreturn_t davinci_musb_interrupt(int irq, void=
 *__hci)
 		davinci_musb_source_power(musb, drvvbus, 0);
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				err ? " ERROR" : "",
 				devctl);
 		retval =3D IRQ_HANDLED;
@@ -361,7 +361,7 @@ static irqreturn_t davinci_musb_interrupt(int irq, void=
 *__hci)
 	musb_writel(tibase, DAVINCI_USB_EOI_REG, 0);
=20
 	/* poll for ID change */
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE)
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index e46e295..df9c5fa 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -360,23 +360,23 @@ static void musb_otg_timer_func(unsigned long data)
 	unsigned long	flags;
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_B_WAIT_ACON:
 		dev_dbg(musb->controller, "HNP: b_wait_acon timeout; back to b_periphera=
l\n");
 		musb_g_disconnect(musb);
-		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 		musb->is_active =3D 0;
 		break;
 	case OTG_STATE_A_SUSPEND:
 	case OTG_STATE_A_WAIT_BCON:
 		dev_dbg(musb->controller, "HNP: %s timeout\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		musb_platform_set_vbus(musb, 0);
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 		break;
 	default:
 		dev_dbg(musb->controller, "HNP: Unhandled mode %s\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
 }
@@ -391,19 +391,19 @@ void musb_hnp_stop(struct musb *musb)
 	u8	reg;
=20
 	dev_dbg(musb->controller, "HNP: stop from %s\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_PERIPHERAL:
 		musb_g_disconnect(musb);
 		dev_dbg(musb->controller, "HNP: back to %s\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		break;
 	case OTG_STATE_B_HOST:
 		dev_dbg(musb->controller, "HNP: Disabling HR\n");
 		if (hcd)
 			hcd->self.is_b_host =3D 0;
-		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 		MUSB_DEV_MODE(musb);
 		reg =3D musb_readb(mbase, MUSB_POWER);
 		reg |=3D MUSB_POWER_SUSPENDM;
@@ -412,7 +412,7 @@ void musb_hnp_stop(struct musb *musb)
 		break;
 	default:
 		dev_dbg(musb->controller, "HNP: Stopping in unknown state %s\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 	}
=20
 	/*
@@ -449,13 +449,13 @@ static irqreturn_t musb_stage0_irq(struct musb *musb,=
 u8 int_usb,
 	 */
 	if (int_usb & MUSB_INTR_RESUME) {
 		handled =3D IRQ_HANDLED;
-		dev_dbg(musb->controller, "RESUME (%s)\n", usb_otg_state_string(musb->xc=
eiv->state));
+		dev_dbg(musb->controller, "RESUME (%s)\n", usb_otg_state_string(musb->xc=
eiv->otg->state));
=20
 		if (devctl & MUSB_DEVCTL_HM) {
 			void __iomem *mbase =3D musb->mregs;
 			u8 power;
=20
-			switch (musb->xceiv->state) {
+			switch (musb->xceiv->otg->state) {
 			case OTG_STATE_A_SUSPEND:
 				/* remote wakeup?  later, GetPortStatus
 				 * will stop RESUME signaling
@@ -482,25 +482,25 @@ static irqreturn_t musb_stage0_irq(struct musb *musb,=
 u8 int_usb,
 					&musb->finish_resume_work,
 					msecs_to_jiffies(20));
=20
-				musb->xceiv->state =3D OTG_STATE_A_HOST;
+				musb->xceiv->otg->state =3D OTG_STATE_A_HOST;
 				musb->is_active =3D 1;
 				musb_host_resume_root_hub(musb);
 				break;
 			case OTG_STATE_B_WAIT_ACON:
-				musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+				musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 				musb->is_active =3D 1;
 				MUSB_DEV_MODE(musb);
 				break;
 			default:
 				WARNING("bogus %s RESUME (%s)\n",
 					"host",
-					usb_otg_state_string(musb->xceiv->state));
+					usb_otg_state_string(musb->xceiv->otg->state));
 			}
 		} else {
-			switch (musb->xceiv->state) {
+			switch (musb->xceiv->otg->state) {
 			case OTG_STATE_A_SUSPEND:
 				/* possibly DISCONNECT is upcoming */
-				musb->xceiv->state =3D OTG_STATE_A_HOST;
+				musb->xceiv->otg->state =3D OTG_STATE_A_HOST;
 				musb_host_resume_root_hub(musb);
 				break;
 			case OTG_STATE_B_WAIT_ACON:
@@ -523,7 +523,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 			default:
 				WARNING("bogus %s RESUME (%s)\n",
 					"peripheral",
-					usb_otg_state_string(musb->xceiv->state));
+					usb_otg_state_string(musb->xceiv->otg->state));
 			}
 		}
 	}
@@ -539,7 +539,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 		}
=20
 		dev_dbg(musb->controller, "SESSION_REQUEST (%s)\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
=20
 		/* IRQ arrives from ID pin sense or (later, if VBUS power
 		 * is removed) SRP.  responses are time critical:
@@ -550,7 +550,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 		 */
 		musb_writeb(mbase, MUSB_DEVCTL, MUSB_DEVCTL_SESSION);
 		musb->ep0_stage =3D MUSB_EP0_START;
-		musb->xceiv->state =3D OTG_STATE_A_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		MUSB_HST_MODE(musb);
 		musb_platform_set_vbus(musb, 1);
=20
@@ -576,7 +576,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 		 * REVISIT:  do delays from lots of DEBUG_KERNEL checks
 		 * make trouble here, keeping VBUS < 4.4V ?
 		 */
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_A_HOST:
 			/* recovery is dicey once we've gotten past the
 			 * initial stages of enumeration, but if VBUS
@@ -605,7 +605,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
=20
 		dev_printk(ignore ? KERN_DEBUG : KERN_ERR, musb->controller,
 				"VBUS_ERROR in %s (%02x, %s), retry #%d, port1 %08x\n",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				devctl,
 				({ char *s;
 				switch (devctl & MUSB_DEVCTL_VBUS) {
@@ -630,10 +630,10 @@ static irqreturn_t musb_stage0_irq(struct musb *musb,=
 u8 int_usb,
=20
 	if (int_usb & MUSB_INTR_SUSPEND) {
 		dev_dbg(musb->controller, "SUSPEND (%s) devctl %02x\n",
-			usb_otg_state_string(musb->xceiv->state), devctl);
+			usb_otg_state_string(musb->xceiv->otg->state), devctl);
 		handled =3D IRQ_HANDLED;
=20
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_A_PERIPHERAL:
 			/* We also come here if the cable is removed, since
 			 * this silicon doesn't report ID-no-longer-grounded.
@@ -657,7 +657,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 			musb_g_suspend(musb);
 			musb->is_active =3D musb->g.b_hnp_enable;
 			if (musb->is_active) {
-				musb->xceiv->state =3D OTG_STATE_B_WAIT_ACON;
+				musb->xceiv->otg->state =3D OTG_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
 				mod_timer(&musb->otg_timer, jiffies
 					+ msecs_to_jiffies(
@@ -670,7 +670,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 					+ msecs_to_jiffies(musb->a_wait_bcon));
 			break;
 		case OTG_STATE_A_HOST:
-			musb->xceiv->state =3D OTG_STATE_A_SUSPEND;
+			musb->xceiv->otg->state =3D OTG_STATE_A_SUSPEND;
 			musb->is_active =3D musb->hcd->self.b_hnp_enable;
 			break;
 		case OTG_STATE_B_HOST:
@@ -713,7 +713,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 			musb->port1_status |=3D USB_PORT_STAT_LOW_SPEED;
=20
 		/* indicate new connection to OTG machine */
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_B_PERIPHERAL:
 			if (int_usb & MUSB_INTR_SUSPEND) {
 				dev_dbg(musb->controller, "HNP: SUSPEND+CONNECT, now b_host\n");
@@ -725,7 +725,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u=
8 int_usb,
 		case OTG_STATE_B_WAIT_ACON:
 			dev_dbg(musb->controller, "HNP: CONNECT, now b_host\n");
 b_host:
-			musb->xceiv->state =3D OTG_STATE_B_HOST;
+			musb->xceiv->otg->state =3D OTG_STATE_B_HOST;
 			if (musb->hcd)
 				musb->hcd->self.is_b_host =3D 1;
 			del_timer(&musb->otg_timer);
@@ -733,7 +733,7 @@ b_host:
 		default:
 			if ((devctl & MUSB_DEVCTL_VBUS)
 					=3D=3D (3 << MUSB_DEVCTL_VBUS_SHIFT)) {
-				musb->xceiv->state =3D OTG_STATE_A_HOST;
+				musb->xceiv->otg->state =3D OTG_STATE_A_HOST;
 				if (hcd)
 					hcd->self.is_b_host =3D 0;
 			}
@@ -743,16 +743,16 @@ b_host:
 		musb_host_poke_root_hub(musb);
=20
 		dev_dbg(musb->controller, "CONNECT (%s) devctl %02x\n",
-				usb_otg_state_string(musb->xceiv->state), devctl);
+				usb_otg_state_string(musb->xceiv->otg->state), devctl);
 	}
=20
 	if (int_usb & MUSB_INTR_DISCONNECT) {
 		dev_dbg(musb->controller, "DISCONNECT (%s) as %s, devctl %02x\n",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				MUSB_MODE(musb), devctl);
 		handled =3D IRQ_HANDLED;
=20
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_A_HOST:
 		case OTG_STATE_A_SUSPEND:
 			musb_host_resume_root_hub(musb);
@@ -770,7 +770,7 @@ b_host:
 			musb_root_disconnect(musb);
 			if (musb->hcd)
 				musb->hcd->self.is_b_host =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+			musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 			MUSB_DEV_MODE(musb);
 			musb_g_disconnect(musb);
 			break;
@@ -786,7 +786,7 @@ b_host:
 			break;
 		default:
 			WARNING("unhandled DISCONNECT transition (%s)\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 			break;
 		}
 	}
@@ -812,15 +812,15 @@ b_host:
 			}
 		} else {
 			dev_dbg(musb->controller, "BUS RESET as %s\n",
-				usb_otg_state_string(musb->xceiv->state));
-			switch (musb->xceiv->state) {
+				usb_otg_state_string(musb->xceiv->otg->state));
+			switch (musb->xceiv->otg->state) {
 			case OTG_STATE_A_SUSPEND:
 				musb_g_reset(musb);
 				/* FALLTHROUGH */
 			case OTG_STATE_A_WAIT_BCON:	/* OPT TD.4.7-900ms */
 				/* never use invalid T(a_wait_bcon) */
 				dev_dbg(musb->controller, "HNP: in %s, %d msec timeout\n",
-					usb_otg_state_string(musb->xceiv->state),
+					usb_otg_state_string(musb->xceiv->otg->state),
 					TA_WAIT_BCON(musb));
 				mod_timer(&musb->otg_timer, jiffies
 					+ msecs_to_jiffies(TA_WAIT_BCON(musb)));
@@ -831,19 +831,19 @@ b_host:
 				break;
 			case OTG_STATE_B_WAIT_ACON:
 				dev_dbg(musb->controller, "HNP: RESET (%s), to b_peripheral\n",
-					usb_otg_state_string(musb->xceiv->state));
-				musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+					usb_otg_state_string(musb->xceiv->otg->state));
+				musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 				musb_g_reset(musb);
 				break;
 			case OTG_STATE_B_IDLE:
-				musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+				musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 				/* FALLTHROUGH */
 			case OTG_STATE_B_PERIPHERAL:
 				musb_g_reset(musb);
 				break;
 			default:
 				dev_dbg(musb->controller, "Unhandled BUS RESET as %s\n",
-					usb_otg_state_string(musb->xceiv->state));
+					usb_otg_state_string(musb->xceiv->otg->state));
 			}
 		}
 	}
@@ -1630,7 +1630,7 @@ musb_mode_show(struct device *dev, struct device_attr=
ibute *attr, char *buf)
 	int ret =3D -EINVAL;
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	ret =3D sprintf(buf, "%s\n", usb_otg_state_string(musb->xceiv->state));
+	ret =3D sprintf(buf, "%s\n", usb_otg_state_string(musb->xceiv->otg->state=
));
 	spin_unlock_irqrestore(&musb->lock, flags);
=20
 	return ret;
@@ -1675,7 +1675,7 @@ musb_vbus_store(struct device *dev, struct device_att=
ribute *attr,
 	spin_lock_irqsave(&musb->lock, flags);
 	/* force T(a_wait_bcon) to be zero/unlimited *OR* valid */
 	musb->a_wait_bcon =3D val ? max_t(int, val, OTG_TIME_A_WAIT_BCON) : 0 ;
-	if (musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON)
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON)
 		musb->is_active =3D 0;
 	musb_platform_try_idle(musb, jiffies + msecs_to_jiffies(val));
 	spin_unlock_irqrestore(&musb->lock, flags);
@@ -1743,8 +1743,8 @@ static void musb_irq_work(struct work_struct *data)
 {
 	struct musb *musb =3D container_of(data, struct musb, irq_work);
=20
-	if (musb->xceiv->state !=3D musb->xceiv_old_state) {
-		musb->xceiv_old_state =3D musb->xceiv->state;
+	if (musb->xceiv->otg->state !=3D musb->xceiv_old_state) {
+		musb->xceiv_old_state =3D musb->xceiv->otg->state;
 		sysfs_notify(&musb->controller->kobj, NULL, "mode");
 	}
 }
@@ -1983,10 +1983,10 @@ musb_init_controller(struct device *dev, int nIrq, =
void __iomem *ctrl)
=20
 	if (musb->xceiv->otg->default_a) {
 		MUSB_HST_MODE(musb);
-		musb->xceiv->state =3D OTG_STATE_A_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 	} else {
 		MUSB_DEV_MODE(musb);
-		musb->xceiv->state =3D OTG_STATE_B_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 	}
=20
 	switch (musb->port_mode) {
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 759ef1d..440333f 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -179,9 +179,9 @@ static void dsps_musb_try_idle(struct musb *musb, unsig=
ned long timeout)
=20
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || (musb->a_wait_bcon =3D=3D 0 &&
-				musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
+			musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON)) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 		del_timer(&glue->timer);
 		glue->last_timer =3D jiffies;
 		return;
@@ -201,7 +201,7 @@ static void dsps_musb_try_idle(struct musb *musb, unsig=
ned long timeout)
 	glue->last_timer =3D timeout;
=20
 	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 			jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&glue->timer, timeout);
 }
@@ -265,10 +265,10 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl =3D dsps_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "Poll devctl %02x (%s)\n", devctl,
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
=20
 	spin_lock_irqsave(&musb->lock, flags);
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
 		dsps_writeb(musb->mregs, MUSB_DEVCTL, 0);
 		skip_session =3D 1;
@@ -277,10 +277,10 @@ static void otg_timer(unsigned long _musb)
 	case OTG_STATE_A_IDLE:
 	case OTG_STATE_B_IDLE:
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		if (!(devctl & MUSB_DEVCTL_SESSION) && !skip_session)
@@ -288,7 +288,7 @@ static void otg_timer(unsigned long _musb)
 		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 		break;
 	case OTG_STATE_A_WAIT_VFALL:
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		dsps_writel(musb->ctrl_base, wrp->coreintr_set,
 			    MUSB_INTR_VBUSERROR << wrp->usb_shift);
 		break;
@@ -373,26 +373,26 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 			 * devctl.
 			 */
 			musb->int_usb &=3D ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 			mod_timer(&glue->timer,
 					jiffies + wrp->poll_seconds * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (drvvbus) {
 			MUSB_HST_MODE(musb);
 			musb->xceiv->otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			del_timer(&glue->timer);
 		} else {
 			musb->is_active =3D 0;
 			MUSB_DEV_MODE(musb);
 			musb->xceiv->otg->default_a =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		}
=20
 		/* NOTE: this must complete power-on within 100 ms. */
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				usb_otg_state_string(musb->xceiv->state),
+				usb_otg_state_string(musb->xceiv->otg->state),
 				err ? " ERROR" : "",
 				devctl);
 		ret =3D IRQ_HANDLED;
@@ -402,7 +402,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 		ret |=3D musb_interrupt(musb);
=20
 	/* Poll for ID change in OTG port mode */
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE &&
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE &&
 			musb->port_mode =3D=3D MUSB_PORT_MODE_DUAL_ROLE)
 		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 out:
@@ -900,7 +900,7 @@ static int dsps_resume(struct device *dev)
 	dsps_writel(mbase, wrp->mode, glue->context.mode);
 	dsps_writel(mbase, wrp->tx_mode, glue->context.tx_mode);
 	dsps_writel(mbase, wrp->rx_mode, glue->context.rx_mode);
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE &&
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE &&
 	    musb->port_mode =3D=3D MUSB_PORT_MODE_DUAL_ROLE)
 		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
=20
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 4ab1896..56c31b7 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1546,7 +1546,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadg=
et)
=20
 	spin_lock_irqsave(&musb->lock, flags);
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_B_PERIPHERAL:
 		/* NOTE:  OTG state machine doesn't include B_SUSPENDED;
 		 * that's part of the standard usb 1.1 state machine, and
@@ -1587,7 +1587,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadg=
et)
 		goto done;
 	default:
 		dev_dbg(musb->controller, "Unhandled wake: %s\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		goto done;
 	}
=20
@@ -1791,7 +1791,7 @@ int musb_gadget_setup(struct musb *musb)
=20
 	MUSB_DEV_MODE(musb);
 	musb->xceiv->otg->default_a =3D 0;
-	musb->xceiv->state =3D OTG_STATE_B_IDLE;
+	musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
=20
 	/* this "gadget" abstracts/virtualizes the controller */
 	musb->g.name =3D musb_driver_name;
@@ -1857,7 +1857,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	musb->is_active =3D 1;
=20
 	otg_set_peripheral(otg, &musb->g);
-	musb->xceiv->state =3D OTG_STATE_B_IDLE;
+	musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 	spin_unlock_irqrestore(&musb->lock, flags);
=20
 	musb_start(musb);
@@ -1941,7 +1941,7 @@ static int musb_gadget_stop(struct usb_gadget *g)
=20
 	(void) musb_gadget_vbus_draw(&musb->g, 0);
=20
-	musb->xceiv->state =3D OTG_STATE_UNDEFINED;
+	musb->xceiv->otg->state =3D OTG_STATE_UNDEFINED;
 	stop_activity(musb, NULL);
 	otg_set_peripheral(musb->xceiv->otg, NULL);
=20
@@ -1968,7 +1968,7 @@ static int musb_gadget_stop(struct usb_gadget *g)
 void musb_g_resume(struct musb *musb)
 {
 	musb->is_suspended =3D 0;
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_B_IDLE:
 		break;
 	case OTG_STATE_B_WAIT_ACON:
@@ -1982,7 +1982,7 @@ void musb_g_resume(struct musb *musb)
 		break;
 	default:
 		WARNING("unhandled RESUME transition (%s)\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 	}
 }
=20
@@ -1994,10 +1994,10 @@ void musb_g_suspend(struct musb *musb)
 	devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "devctl %02x\n", devctl);
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_B_IDLE:
 		if ((devctl & MUSB_DEVCTL_VBUS) =3D=3D MUSB_DEVCTL_VBUS)
-			musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+			musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 		break;
 	case OTG_STATE_B_PERIPHERAL:
 		musb->is_suspended =3D 1;
@@ -2012,7 +2012,7 @@ void musb_g_suspend(struct musb *musb)
 		 * A_PERIPHERAL may need care too
 		 */
 		WARNING("unhandled SUSPEND transition (%s)\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 	}
 }
=20
@@ -2043,22 +2043,22 @@ void musb_g_disconnect(struct musb *musb)
 		spin_lock(&musb->lock);
 	}
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	default:
 		dev_dbg(musb->controller, "Unhandled disconnect %s, setting a_idle\n",
-			usb_otg_state_string(musb->xceiv->state));
-		musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			usb_otg_state_string(musb->xceiv->otg->state));
+		musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		MUSB_HST_MODE(musb);
 		break;
 	case OTG_STATE_A_PERIPHERAL:
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 		MUSB_HST_MODE(musb);
 		break;
 	case OTG_STATE_B_WAIT_ACON:
 	case OTG_STATE_B_HOST:
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_IDLE:
-		musb->xceiv->state =3D OTG_STATE_B_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		break;
 	case OTG_STATE_B_SRP_INIT:
 		break;
@@ -2118,13 +2118,13 @@ __acquires(musb->lock)
 		 * In that case, do not rely on devctl for setting
 		 * peripheral mode.
 		 */
-		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 		musb->g.is_a_peripheral =3D 0;
 	} else if (devctl & MUSB_DEVCTL_BDEVICE) {
-		musb->xceiv->state =3D OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->otg->state =3D OTG_STATE_B_PERIPHERAL;
 		musb->g.is_a_peripheral =3D 0;
 	} else {
-		musb->xceiv->state =3D OTG_STATE_A_PERIPHERAL;
+		musb->xceiv->otg->state =3D OTG_STATE_A_PERIPHERAL;
 		musb->g.is_a_peripheral =3D 1;
 	}
=20
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 855793d..23d474d 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2463,7 +2463,7 @@ static int musb_bus_suspend(struct usb_hcd *hcd)
 	if (!is_host_active(musb))
 		return 0;
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_SUSPEND:
 		return 0;
 	case OTG_STATE_A_WAIT_VRISE:
@@ -2473,7 +2473,7 @@ static int musb_bus_suspend(struct usb_hcd *hcd)
 		 */
 		devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 		if ((devctl & MUSB_DEVCTL_VBUS) =3D=3D MUSB_DEVCTL_VBUS)
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 		break;
 	default:
 		break;
@@ -2481,7 +2481,7 @@ static int musb_bus_suspend(struct usb_hcd *hcd)
=20
 	if (musb->is_active) {
 		WARNING("trying to suspend as %s while active\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 		return -EBUSY;
 	} else
 		return 0;
@@ -2678,7 +2678,7 @@ int musb_host_setup(struct musb *musb, int power_budg=
et)
=20
 	MUSB_HST_MODE(musb);
 	musb->xceiv->otg->default_a =3D 1;
-	musb->xceiv->state =3D OTG_STATE_A_IDLE;
+	musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
=20
 	otg_set_host(musb->xceiv->otg, &hcd->self);
 	hcd->self.otg_port =3D 1;
diff --git a/drivers/usb/musb/musb_virthub.c b/drivers/usb/musb/musb_virthu=
b.c
index e2d2d8c..a133bd8 100644
--- a/drivers/usb/musb/musb_virthub.c
+++ b/drivers/usb/musb/musb_virthub.c
@@ -69,7 +69,7 @@ void musb_host_finish_resume(struct work_struct *work)
 	musb->port1_status |=3D USB_PORT_STAT_C_SUSPEND << 16;
 	usb_hcd_poll_rh_status(musb->hcd);
 	/* NOTE: it might really be A_WAIT_BCON ... */
-	musb->xceiv->state =3D OTG_STATE_A_HOST;
+	musb->xceiv->otg->state =3D OTG_STATE_A_HOST;
=20
 	spin_unlock_irqrestore(&musb->lock, flags);
 }
@@ -107,9 +107,9 @@ void musb_port_suspend(struct musb *musb, bool do_suspe=
nd)
 		dev_dbg(musb->controller, "Root port suspended, power %02x\n", power);
=20
 		musb->port1_status |=3D USB_PORT_STAT_SUSPEND;
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_A_HOST:
-			musb->xceiv->state =3D OTG_STATE_A_SUSPEND;
+			musb->xceiv->otg->state =3D OTG_STATE_A_SUSPEND;
 			musb->is_active =3D otg->host->b_hnp_enable;
 			if (musb->is_active)
 				mod_timer(&musb->otg_timer, jiffies
@@ -118,13 +118,13 @@ void musb_port_suspend(struct musb *musb, bool do_sus=
pend)
 			musb_platform_try_idle(musb, 0);
 			break;
 		case OTG_STATE_B_HOST:
-			musb->xceiv->state =3D OTG_STATE_B_WAIT_ACON;
+			musb->xceiv->otg->state =3D OTG_STATE_B_WAIT_ACON;
 			musb->is_active =3D otg->host->b_hnp_enable;
 			musb_platform_try_idle(musb, 0);
 			break;
 		default:
 			dev_dbg(musb->controller, "bogus rh suspend? %s\n",
-				usb_otg_state_string(musb->xceiv->state));
+				usb_otg_state_string(musb->xceiv->otg->state));
 		}
 	} else if (power & MUSB_POWER_SUSPENDM) {
 		power &=3D ~MUSB_POWER_SUSPENDM;
@@ -145,7 +145,7 @@ void musb_port_reset(struct musb *musb, bool do_reset)
 	u8		power;
 	void __iomem	*mbase =3D musb->mregs;
=20
-	if (musb->xceiv->state =3D=3D OTG_STATE_B_IDLE) {
+	if (musb->xceiv->otg->state =3D=3D OTG_STATE_B_IDLE) {
 		dev_dbg(musb->controller, "HNP: Returning from HNP; no hub reset from b_=
idle\n");
 		musb->port1_status &=3D ~USB_PORT_STAT_RESET;
 		return;
@@ -224,24 +224,24 @@ void musb_root_disconnect(struct musb *musb)
 	usb_hcd_poll_rh_status(musb->hcd);
 	musb->is_active =3D 0;
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_SUSPEND:
 		if (otg->host->b_hnp_enable) {
-			musb->xceiv->state =3D OTG_STATE_A_PERIPHERAL;
+			musb->xceiv->otg->state =3D OTG_STATE_A_PERIPHERAL;
 			musb->g.is_a_peripheral =3D 1;
 			break;
 		}
 		/* FALLTHROUGH */
 	case OTG_STATE_A_HOST:
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 		musb->is_active =3D 0;
 		break;
 	case OTG_STATE_A_WAIT_VFALL:
-		musb->xceiv->state =3D OTG_STATE_B_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		break;
 	default:
 		dev_dbg(musb->controller, "host disconnect (%s)\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 	}
 }
=20
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 20fc2a5..763649e 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -65,15 +65,15 @@ static void musb_do_idle(unsigned long _musb)
=20
 	spin_lock_irqsave(&musb->lock, flags);
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
=20
 		devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state =3D OTG_STATE_A_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
@@ -90,15 +90,15 @@ static void musb_do_idle(unsigned long _musb)
 			musb->port1_status |=3D USB_PORT_STAT_C_SUSPEND << 16;
 			usb_hcd_poll_rh_status(musb->hcd);
 			/* NOTE: it might really be A_WAIT_BCON ... */
-			musb->xceiv->state =3D OTG_STATE_A_HOST;
+			musb->xceiv->otg->state =3D OTG_STATE_A_HOST;
 		}
 		break;
 	case OTG_STATE_A_HOST:
 		devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl &  MUSB_DEVCTL_BDEVICE)
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		else
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 	default:
 		break;
 	}
@@ -116,9 +116,9 @@ static void omap2430_musb_try_idle(struct musb *musb, u=
nsigned long timeout)
=20
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || ((musb->a_wait_bcon =3D=3D 0)
-			&& (musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON))) {
+			&& (musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON))) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		del_timer(&musb_idle_timer);
 		last_timer =3D jiffies;
 		return;
@@ -135,7 +135,7 @@ static void omap2430_musb_try_idle(struct musb *musb, u=
nsigned long timeout)
 	last_timer =3D timeout;
=20
 	dev_dbg(musb->controller, "%s inactive, for idle timer for %lu ms\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		(unsigned long)jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&musb_idle_timer, timeout);
 }
@@ -153,7 +153,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, i=
nt is_on)
 	devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
=20
 	if (is_on) {
-		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
+		if (musb->xceiv->otg->state =3D=3D OTG_STATE_A_IDLE) {
 			int loops =3D 100;
 			/* start the session */
 			devctl |=3D MUSB_DEVCTL_SESSION;
@@ -180,7 +180,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, i=
nt is_on)
 		} else {
 			musb->is_active =3D 1;
 			otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			devctl |=3D MUSB_DEVCTL_SESSION;
 			MUSB_HST_MODE(musb);
 		}
@@ -192,7 +192,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, i=
nt is_on)
 		 */
=20
 		otg->default_a =3D 0;
-		musb->xceiv->state =3D OTG_STATE_B_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		devctl &=3D ~MUSB_DEVCTL_SESSION;
=20
 		MUSB_DEV_MODE(musb);
@@ -201,7 +201,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, i=
nt is_on)
=20
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x "
 		/* otg %3x conf %08x prcm %08x */ "\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
=20
@@ -266,7 +266,7 @@ static void omap_musb_set_mailbox(struct omap2430_glue =
*glue)
 		dev_dbg(dev, "ID GND\n");
=20
 		otg->default_a =3D true;
-		musb->xceiv->state =3D OTG_STATE_A_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 		musb->xceiv->last_event =3D USB_EVENT_ID;
 		if (musb->gadget_driver) {
 			pm_runtime_get_sync(dev);
@@ -280,7 +280,7 @@ static void omap_musb_set_mailbox(struct omap2430_glue =
*glue)
 		dev_dbg(dev, "VBUS Connect\n");
=20
 		otg->default_a =3D false;
-		musb->xceiv->state =3D OTG_STATE_B_IDLE;
+		musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		musb->xceiv->last_event =3D USB_EVENT_VBUS;
 		if (musb->gadget_driver)
 			pm_runtime_get_sync(dev);
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 25f02df..69ca92d6 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -415,13 +415,13 @@ static void musb_do_idle(unsigned long _musb)
=20
 	spin_lock_irqsave(&musb->lock, flags);
=20
-	switch (musb->xceiv->state) {
+	switch (musb->xceiv->otg->state) {
 	case OTG_STATE_A_WAIT_BCON:
 		if ((musb->a_wait_bcon !=3D 0)
 			&& (musb->idle_timeout =3D=3D 0
 				|| time_after(jiffies, musb->idle_timeout))) {
 			dev_dbg(musb->controller, "Nothing connected %s, turning off VBUS\n",
-					usb_otg_state_string(musb->xceiv->state));
+					usb_otg_state_string(musb->xceiv->otg->state));
 		}
 		/* FALLTHROUGH */
 	case OTG_STATE_A_IDLE:
@@ -474,9 +474,9 @@ static void tusb_musb_try_idle(struct musb *musb, unsig=
ned long timeout)
=20
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || ((musb->a_wait_bcon =3D=3D 0)
-			&& (musb->xceiv->state =3D=3D OTG_STATE_A_WAIT_BCON))) {
+			&& (musb->xceiv->otg->state =3D=3D OTG_STATE_A_WAIT_BCON))) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			usb_otg_state_string(musb->xceiv->state));
+			usb_otg_state_string(musb->xceiv->otg->state));
 		del_timer(&musb_idle_timer);
 		last_timer =3D jiffies;
 		return;
@@ -493,7 +493,7 @@ static void tusb_musb_try_idle(struct musb *musb, unsig=
ned long timeout)
 	last_timer =3D timeout;
=20
 	dev_dbg(musb->controller, "%s inactive, for idle timer for %lu ms\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		(unsigned long)jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&musb_idle_timer, timeout);
 }
@@ -524,7 +524,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int i=
s_on)
 	if (is_on) {
 		timer =3D OTG_TIMER_MS(OTG_TIME_A_WAIT_VRISE);
 		otg->default_a =3D 1;
-		musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		devctl |=3D MUSB_DEVCTL_SESSION;
=20
 		conf |=3D TUSB_DEV_CONF_USB_HOST_MODE;
@@ -537,16 +537,16 @@ static void tusb_musb_set_vbus(struct musb *musb, int=
 is_on)
 		/* If ID pin is grounded, we want to be a_idle */
 		otg_stat =3D musb_readl(tbase, TUSB_DEV_OTG_STAT);
 		if (!(otg_stat & TUSB_DEV_OTG_STAT_ID_STATUS)) {
-			switch (musb->xceiv->state) {
+			switch (musb->xceiv->otg->state) {
 			case OTG_STATE_A_WAIT_VRISE:
 			case OTG_STATE_A_WAIT_BCON:
-				musb->xceiv->state =3D OTG_STATE_A_WAIT_VFALL;
+				musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VFALL;
 				break;
 			case OTG_STATE_A_WAIT_VFALL:
-				musb->xceiv->state =3D OTG_STATE_A_IDLE;
+				musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 				break;
 			default:
-				musb->xceiv->state =3D OTG_STATE_A_IDLE;
+				musb->xceiv->otg->state =3D OTG_STATE_A_IDLE;
 			}
 			musb->is_active =3D 0;
 			otg->default_a =3D 1;
@@ -554,7 +554,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int i=
s_on)
 		} else {
 			musb->is_active =3D 0;
 			otg->default_a =3D 0;
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		}
=20
@@ -569,7 +569,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int i=
s_on)
 	musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
=20
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x otg %3x conf %08x prcm %0=
8x\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL),
 		musb_readl(tbase, TUSB_DEV_OTG_STAT),
 		conf, prcm);
@@ -668,23 +668,23 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __=
iomem *tbase)
=20
 			if (otg_stat & TUSB_DEV_OTG_STAT_SESS_END) {
 				dev_dbg(musb->controller, "Forcing disconnect (no interrupt)\n");
-				if (musb->xceiv->state !=3D OTG_STATE_B_IDLE) {
+				if (musb->xceiv->otg->state !=3D OTG_STATE_B_IDLE) {
 					/* INTR_DISCONNECT can hide... */
-					musb->xceiv->state =3D OTG_STATE_B_IDLE;
+					musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 					musb->int_usb |=3D MUSB_INTR_DISCONNECT;
 				}
 				musb->is_active =3D 0;
 			}
 			dev_dbg(musb->controller, "vbus change, %s, otg %03x\n",
-				usb_otg_state_string(musb->xceiv->state), otg_stat);
+				usb_otg_state_string(musb->xceiv->otg->state), otg_stat);
 			idle_timeout =3D jiffies + (1 * HZ);
 			schedule_work(&musb->irq_work);
=20
 		} else /* A-dev state machine */ {
 			dev_dbg(musb->controller, "vbus change, %s, otg %03x\n",
-				usb_otg_state_string(musb->xceiv->state), otg_stat);
+				usb_otg_state_string(musb->xceiv->otg->state), otg_stat);
=20
-			switch (musb->xceiv->state) {
+			switch (musb->xceiv->otg->state) {
 			case OTG_STATE_A_IDLE:
 				dev_dbg(musb->controller, "Got SRP, turning on VBUS\n");
 				musb_platform_set_vbus(musb, 1);
@@ -731,9 +731,9 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __io=
mem *tbase)
 		u8	devctl;
=20
 		dev_dbg(musb->controller, "%s timer, %03x\n",
-			usb_otg_state_string(musb->xceiv->state), otg_stat);
+			usb_otg_state_string(musb->xceiv->otg->state), otg_stat);
=20
-		switch (musb->xceiv->state) {
+		switch (musb->xceiv->otg->state) {
 		case OTG_STATE_A_WAIT_VRISE:
 			/* VBUS has probably been valid for a while now,
 			 * but may well have bounced out of range a bit
@@ -745,7 +745,7 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __io=
mem *tbase)
 					dev_dbg(musb->controller, "devctl %02x\n", devctl);
 					break;
 				}
-				musb->xceiv->state =3D OTG_STATE_A_WAIT_BCON;
+				musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_BCON;
 				musb->is_active =3D 0;
 				idle_timeout =3D jiffies
 					+ msecs_to_jiffies(musb->a_wait_bcon);
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index d0180a7..1d631d5 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -56,7 +56,7 @@ static void ux500_musb_set_vbus(struct musb *musb, int is=
_on)
 	devctl =3D musb_readb(musb->mregs, MUSB_DEVCTL);
=20
 	if (is_on) {
-		if (musb->xceiv->state =3D=3D OTG_STATE_A_IDLE) {
+		if (musb->xceiv->otg->state =3D=3D OTG_STATE_A_IDLE) {
 			/* start the session */
 			devctl |=3D MUSB_DEVCTL_SESSION;
 			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
@@ -76,7 +76,7 @@ static void ux500_musb_set_vbus(struct musb *musb, int is=
_on)
 		} else {
 			musb->is_active =3D 1;
 			musb->xceiv->otg->default_a =3D 1;
-			musb->xceiv->state =3D OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			devctl |=3D MUSB_DEVCTL_SESSION;
 			MUSB_HST_MODE(musb);
 		}
@@ -102,7 +102,7 @@ static void ux500_musb_set_vbus(struct musb *musb, int =
is_on)
 		mdelay(200);
=20
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x\n",
-		usb_otg_state_string(musb->xceiv->state),
+		usb_otg_state_string(musb->xceiv->otg->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
=20
@@ -112,7 +112,7 @@ static int musb_otg_notifications(struct notifier_block=
 *nb,
 	struct musb *musb =3D container_of(nb, struct musb, nb);
=20
 	dev_dbg(musb->controller, "musb_otg_notifications %ld %s\n",
-			event, usb_otg_state_string(musb->xceiv->state));
+			event, usb_otg_state_string(musb->xceiv->otg->state));
=20
 	switch (event) {
 	case UX500_MUSB_ID:
@@ -127,7 +127,7 @@ static int musb_otg_notifications(struct notifier_block=
 *nb,
 		if (is_host_active(musb))
 			ux500_musb_set_vbus(musb, 0);
 		else
-			musb->xceiv->state =3D OTG_STATE_B_IDLE;
+			musb->xceiv->otg->state =3D OTG_STATE_B_IDLE;
 		break;
 	default:
 		dev_dbg(musb->controller, "ID float\n");
diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-=
usb.c
index 11ab2c4..2d52501 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -446,7 +446,7 @@ static int ab9540_usb_link_status_update(struct ab8500_=
usb *ab,
 		if (event !=3D UX500_MUSB_RIDB)
 			event =3D UX500_MUSB_NONE;
 		/* Fallback to default B_IDLE as nothing is connected. */
-		ab->phy.state =3D OTG_STATE_B_IDLE;
+		ab->phy.otg->state =3D OTG_STATE_B_IDLE;
 		break;
=20
 	case USB_LINK_ACA_RID_C_NM_9540:
@@ -584,7 +584,7 @@ static int ab8540_usb_link_status_update(struct ab8500_=
usb *ab,
 		 * Fallback to default B_IDLE as nothing
 		 * is connected
 		 */
-		ab->phy.state =3D OTG_STATE_B_IDLE;
+		ab->phy.otg->state =3D OTG_STATE_B_IDLE;
 		break;
=20
 	case USB_LINK_ACA_RID_C_NM_8540:
@@ -693,7 +693,7 @@ static int ab8505_usb_link_status_update(struct ab8500_=
usb *ab,
 		 * Fallback to default B_IDLE as nothing
 		 * is connected
 		 */
-		ab->phy.state =3D OTG_STATE_B_IDLE;
+		ab->phy.otg->state =3D OTG_STATE_B_IDLE;
 		break;
=20
 	case USB_LINK_ACA_RID_C_NM_8505:
@@ -776,7 +776,7 @@ static int ab8500_usb_link_status_update(struct ab8500_=
usb *ab,
 		if (event !=3D UX500_MUSB_RIDB)
 			event =3D UX500_MUSB_NONE;
 		/* Fallback to default B_IDLE as nothing is connected */
-		ab->phy.state =3D OTG_STATE_B_IDLE;
+		ab->phy.otg->state =3D OTG_STATE_B_IDLE;
 		break;
=20
 	case USB_LINK_ACA_RID_C_NM_8500:
@@ -1380,7 +1380,7 @@ static int ab8500_usb_probe(struct platform_device *p=
dev)
 	ab->phy.label		=3D "ab8500";
 	ab->phy.set_suspend	=3D ab8500_usb_set_suspend;
 	ab->phy.set_power	=3D ab8500_usb_set_power;
-	ab->phy.state		=3D OTG_STATE_UNDEFINED;
+	ab->phy.otg->state	=3D OTG_STATE_UNDEFINED;
=20
 	otg->phy		=3D &ab->phy;
 	otg->set_host		=3D ab8500_usb_set_host;
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index f1ea599..15d7a81 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -623,7 +623,7 @@ static int fsl_otg_set_host(struct usb_otg *otg, struct=
 usb_bus *host)
 			/* Mini-A cable connected */
 			struct otg_fsm *fsm =3D &otg_dev->fsm;
=20
-			otg->phy->state =3D OTG_STATE_UNDEFINED;
+			otg.state =3D OTG_STATE_UNDEFINED;
 			fsm->protocol =3D PROTO_UNDEF;
 		}
 	}
@@ -681,7 +681,7 @@ static int fsl_otg_set_power(struct usb_phy *phy, unsig=
ned mA)
 {
 	if (!fsl_otg_dev)
 		return -ENODEV;
-	if (phy->state =3D=3D OTG_STATE_B_PERIPHERAL)
+	if (phy->otg.state =3D=3D OTG_STATE_B_PERIPHERAL)
 		pr_info("FSL OTG: Draw %d mA\n", mA);
=20
 	return 0;
@@ -714,7 +714,7 @@ static int fsl_otg_start_srp(struct usb_otg *otg)
 {
 	struct fsl_otg *otg_dev;
=20
-	if (!otg || otg->phy->state !=3D OTG_STATE_B_IDLE)
+	if (!otg || otg.state !=3D OTG_STATE_B_IDLE)
 		return -ENODEV;
=20
 	otg_dev =3D container_of(otg->phy, struct fsl_otg, phy);
@@ -989,10 +989,10 @@ int usb_otg_start(struct platform_device *pdev)
 	 * Also: record initial state of ID pin
 	 */
 	if (fsl_readl(&p_otg->dr_mem_map->otgsc) & OTGSC_STS_USB_ID) {
-		p_otg->phy.state =3D OTG_STATE_UNDEFINED;
+		p_otg->phy->otg.state =3D OTG_STATE_UNDEFINED;
 		p_otg->fsm.id =3D 1;
 	} else {
-		p_otg->phy.state =3D OTG_STATE_A_IDLE;
+		p_otg->phy->otg.state =3D OTG_STATE_A_IDLE;
 		p_otg->fsm.id =3D 0;
 	}
=20
diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
index 7594e50..280a345 100644
--- a/drivers/usb/phy/phy-generic.c
+++ b/drivers/usb/phy/phy-generic.c
@@ -123,7 +123,7 @@ static int nop_set_peripheral(struct usb_otg *otg, stru=
ct usb_gadget *gadget)
 	}
=20
 	otg->gadget =3D gadget;
-	otg->phy->state =3D OTG_STATE_B_IDLE;
+	otg->state =3D OTG_STATE_B_IDLE;
 	return 0;
 }
=20
@@ -225,9 +225,9 @@ int usb_phy_gen_create_phy(struct device *dev, struct u=
sb_phy_generic *nop,
 	nop->phy.dev		=3D nop->dev;
 	nop->phy.label		=3D "nop-xceiv";
 	nop->phy.set_suspend	=3D nop_set_suspend;
-	nop->phy.state		=3D OTG_STATE_UNDEFINED;
 	nop->phy.type		=3D type;
=20
+	nop->phy.otg->state		=3D OTG_STATE_UNDEFINED;
 	nop->phy.otg->phy		=3D &nop->phy;
 	nop->phy.otg->set_host		=3D nop_set_host;
 	nop->phy.otg->set_peripheral	=3D nop_set_peripheral;
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio=
-vbus-usb.c
index f4b14bd..7a6be3e 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -121,7 +121,7 @@ static void gpio_vbus_work(struct work_struct *work)
=20
 	if (vbus) {
 		status =3D USB_EVENT_VBUS;
-		gpio_vbus->phy.state =3D OTG_STATE_B_PERIPHERAL;
+		gpio_vbus->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 		gpio_vbus->phy.last_event =3D status;
 		usb_gadget_vbus_connect(gpio_vbus->phy.otg->gadget);
=20
@@ -143,7 +143,7 @@ static void gpio_vbus_work(struct work_struct *work)
=20
 		usb_gadget_vbus_disconnect(gpio_vbus->phy.otg->gadget);
 		status =3D USB_EVENT_NONE;
-		gpio_vbus->phy.state =3D OTG_STATE_B_IDLE;
+		gpio_vbus->phy.otg->state =3D OTG_STATE_B_IDLE;
 		gpio_vbus->phy.last_event =3D status;
=20
 		atomic_notifier_call_chain(&gpio_vbus->phy.notifier,
@@ -196,7 +196,7 @@ static int gpio_vbus_set_peripheral(struct usb_otg *otg,
 		set_vbus_draw(gpio_vbus, 0);
=20
 		usb_gadget_vbus_disconnect(otg->gadget);
-		otg->phy->state =3D OTG_STATE_UNDEFINED;
+		otg->state =3D OTG_STATE_UNDEFINED;
=20
 		otg->gadget =3D NULL;
 		return 0;
@@ -218,7 +218,7 @@ static int gpio_vbus_set_power(struct usb_phy *phy, uns=
igned mA)
=20
 	gpio_vbus =3D container_of(phy, struct gpio_vbus_data, phy);
=20
-	if (phy->state =3D=3D OTG_STATE_B_PERIPHERAL)
+	if (phy->otg->state =3D=3D OTG_STATE_B_PERIPHERAL)
 		set_vbus_draw(gpio_vbus, mA);
 	return 0;
 }
@@ -269,8 +269,8 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	gpio_vbus->phy.dev =3D gpio_vbus->dev;
 	gpio_vbus->phy.set_power =3D gpio_vbus_set_power;
 	gpio_vbus->phy.set_suspend =3D gpio_vbus_set_suspend;
-	gpio_vbus->phy.state =3D OTG_STATE_UNDEFINED;
=20
+	gpio_vbus->phy.otg->state =3D OTG_STATE_UNDEFINED;
 	gpio_vbus->phy.otg->phy =3D &gpio_vbus->phy;
 	gpio_vbus->phy.otg->set_peripheral =3D gpio_vbus_set_peripheral;
=20
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp13=
01-omap.c
index 8eea56d..24f84cb 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -234,7 +234,7 @@ isp1301_clear_bits(struct isp1301 *isp, u8 reg, u8 bits)
=20
 static inline const char *state_name(struct isp1301 *isp)
 {
-	return usb_otg_state_string(isp->phy.state);
+	return usb_otg_state_string(isp->phy.otg->state);
 }
=20
 /*------------------------------------------------------------------------=
-*/
@@ -249,7 +249,7 @@ static inline const char *state_name(struct isp1301 *is=
p)
=20
 static void power_down(struct isp1301 *isp)
 {
-	isp->phy.state =3D OTG_STATE_UNDEFINED;
+	isp->phy.otg->state =3D OTG_STATE_UNDEFINED;
=20
 	// isp1301_set_bits(isp, ISP1301_MODE_CONTROL_2, MC2_GLOBAL_PWR_DN);
 	isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_SUSPEND);
@@ -339,7 +339,7 @@ static void a_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
=20
-	if (isp->phy.state =3D=3D OTG_STATE_A_IDLE)
+	if (isp->phy.otg->state =3D=3D OTG_STATE_A_IDLE)
 		return;
=20
 	isp->phy.otg->default_a =3D 1;
@@ -351,7 +351,7 @@ static void a_idle(struct isp1301 *isp, const char *tag)
 		isp->phy.otg->gadget->is_a_peripheral =3D 1;
 		gadget_suspend(isp);
 	}
-	isp->phy.state =3D OTG_STATE_A_IDLE;
+	isp->phy.otg->state =3D OTG_STATE_A_IDLE;
 	l =3D omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl =3D l;
@@ -363,7 +363,7 @@ static void b_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
=20
-	if (isp->phy.state =3D=3D OTG_STATE_B_IDLE)
+	if (isp->phy.otg->state =3D=3D OTG_STATE_B_IDLE)
 		return;
=20
 	isp->phy.otg->default_a =3D 0;
@@ -375,7 +375,7 @@ static void b_idle(struct isp1301 *isp, const char *tag)
 		isp->phy.otg->gadget->is_a_peripheral =3D 0;
 		gadget_suspend(isp);
 	}
-	isp->phy.state =3D OTG_STATE_B_IDLE;
+	isp->phy.otg->state =3D OTG_STATE_B_IDLE;
 	l =3D omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl =3D l;
@@ -474,7 +474,7 @@ static void check_state(struct isp1301 *isp, const char=
 *tag)
 	default:
 		break;
 	}
-	if (isp->phy.state =3D=3D state && !extra)
+	if (isp->phy.otg->state =3D=3D state && !extra)
 		return;
 	pr_debug("otg: %s FSM %s/%02x, %s, %06x\n", tag,
 		usb_otg_state_string(state), fsm, state_name(isp),
@@ -498,23 +498,23 @@ static void update_otg1(struct isp1301 *isp, u8 int_s=
rc)
=20
 	if (int_src & INTR_SESS_VLD)
 		otg_ctrl |=3D OTG_ASESSVLD;
-	else if (isp->phy.state =3D=3D OTG_STATE_A_WAIT_VFALL) {
+	else if (isp->phy.otg->state =3D=3D OTG_STATE_A_WAIT_VFALL) {
 		a_idle(isp, "vfall");
 		otg_ctrl &=3D ~OTG_CTRL_BITS;
 	}
 	if (int_src & INTR_VBUS_VLD)
 		otg_ctrl |=3D OTG_VBUSVLD;
 	if (int_src & INTR_ID_GND) {		/* default-A */
-		if (isp->phy.state =3D=3D OTG_STATE_B_IDLE
-				|| isp->phy.state
+		if (isp->phy.otg->state =3D=3D OTG_STATE_B_IDLE
+				|| isp->phy.otg->state
 					=3D=3D OTG_STATE_UNDEFINED) {
 			a_idle(isp, "init");
 			return;
 		}
 	} else {				/* default-B */
 		otg_ctrl |=3D OTG_ID;
-		if (isp->phy.state =3D=3D OTG_STATE_A_IDLE
-			|| isp->phy.state =3D=3D OTG_STATE_UNDEFINED) {
+		if (isp->phy.otg->state =3D=3D OTG_STATE_A_IDLE
+			|| isp->phy.otg->state =3D=3D OTG_STATE_UNDEFINED) {
 			b_idle(isp, "init");
 			return;
 		}
@@ -548,14 +548,14 @@ static void otg_update_isp(struct isp1301 *isp)
 	isp->last_otg_ctrl =3D otg_ctrl;
 	otg_ctrl =3D otg_ctrl & OTG_XCEIV_INPUTS;
=20
-	switch (isp->phy.state) {
+	switch (isp->phy.otg->state) {
 	case OTG_STATE_B_IDLE:
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_SRP_INIT:
 		if (!(otg_ctrl & OTG_PULLUP)) {
 			// if (otg_ctrl & OTG_B_HNPEN) {
 			if (isp->phy.otg->gadget->b_hnp_enable) {
-				isp->phy.state =3D OTG_STATE_B_WAIT_ACON;
+				isp->phy.otg->state =3D OTG_STATE_B_WAIT_ACON;
 				pr_debug("  --> b_wait_acon\n");
 			}
 			goto pulldown;
@@ -585,7 +585,7 @@ pulldown:
 	if (!(isp->phy.otg->host))
 		otg_ctrl &=3D ~OTG_DRV_VBUS;
=20
-	switch (isp->phy.state) {
+	switch (isp->phy.otg->state) {
 	case OTG_STATE_A_SUSPEND:
 		if (otg_ctrl & OTG_DRV_VBUS) {
 			set |=3D OTG1_VBUS_DRV;
@@ -596,7 +596,7 @@ pulldown:
=20
 		/* FALLTHROUGH */
 	case OTG_STATE_A_VBUS_ERR:
-		isp->phy.state =3D OTG_STATE_A_WAIT_VFALL;
+		isp->phy.otg->state =3D OTG_STATE_A_WAIT_VFALL;
 		pr_debug("  --> a_wait_vfall\n");
 		/* FALLTHROUGH */
 	case OTG_STATE_A_WAIT_VFALL:
@@ -605,7 +605,7 @@ pulldown:
 		break;
 	case OTG_STATE_A_IDLE:
 		if (otg_ctrl & OTG_DRV_VBUS) {
-			isp->phy.state =3D OTG_STATE_A_WAIT_VRISE;
+			isp->phy.otg->state =3D OTG_STATE_A_WAIT_VRISE;
 			pr_debug("  --> a_wait_vrise\n");
 		}
 		/* FALLTHROUGH */
@@ -625,17 +625,17 @@ pulldown:
 	if (otg_change & OTG_PULLUP) {
 		u32 l;
=20
-		switch (isp->phy.state) {
+		switch (isp->phy.otg->state) {
 		case OTG_STATE_B_IDLE:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->phy.state =3D OTG_STATE_B_PERIPHERAL;
+			isp->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 			pr_debug("  --> b_peripheral\n");
 			break;
 		case OTG_STATE_A_SUSPEND:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->phy.state =3D OTG_STATE_A_PERIPHERAL;
+			isp->phy.otg->state =3D OTG_STATE_A_PERIPHERAL;
 			pr_debug("  --> a_peripheral\n");
 			break;
 		default:
@@ -673,7 +673,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		 * remote wakeup (SRP, normal) using their own timer
 		 * to give "check cable and A-device" messages.
 		 */
-		if (isp->phy.state =3D=3D OTG_STATE_B_SRP_INIT)
+		if (isp->phy.otg->state =3D=3D OTG_STATE_B_SRP_INIT)
 			b_idle(isp, "srp_timeout");
=20
 		omap_writew(B_SRP_TMROUT, OTG_IRQ_SRC);
@@ -691,7 +691,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		omap_writel(otg_ctrl, OTG_CTRL);
=20
 		/* subset of b_peripheral()... */
-		isp->phy.state =3D OTG_STATE_B_PERIPHERAL;
+		isp->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 		pr_debug("  --> b_peripheral\n");
=20
 		omap_writew(B_HNP_FAIL, OTG_IRQ_SRC);
@@ -703,7 +703,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 				state_name(isp), omap_readl(OTG_CTRL));
=20
 		isp1301_defer_work(isp, WORK_UPDATE_OTG);
-		switch (isp->phy.state) {
+		switch (isp->phy.otg->state) {
 		case OTG_STATE_A_IDLE:
 			if (!otg->host)
 				break;
@@ -734,7 +734,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |=3D OTG_BUSDROP;
 		otg_ctrl &=3D ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->phy.state =3D OTG_STATE_A_WAIT_VFALL;
+		isp->phy.otg->state =3D OTG_STATE_A_WAIT_VFALL;
=20
 		omap_writew(A_REQ_TMROUT, OTG_IRQ_SRC);
 		ret =3D IRQ_HANDLED;
@@ -748,7 +748,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |=3D OTG_BUSDROP;
 		otg_ctrl &=3D ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->phy.state =3D OTG_STATE_A_VBUS_ERR;
+		isp->phy.otg->state =3D OTG_STATE_A_VBUS_ERR;
=20
 		omap_writew(A_VBUS_ERR, OTG_IRQ_SRC);
 		ret =3D IRQ_HANDLED;
@@ -769,7 +769,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
=20
 		/* role is peripheral */
 		if (otg_ctrl & OTG_DRIVER_SEL) {
-			switch (isp->phy.state) {
+			switch (isp->phy.otg->state) {
 			case OTG_STATE_A_IDLE:
 				b_idle(isp, __func__);
 				break;
@@ -786,18 +786,18 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 			}
=20
 			if (otg->host) {
-				switch (isp->phy.state) {
+				switch (isp->phy.otg->state) {
 				case OTG_STATE_B_WAIT_ACON:
-					isp->phy.state =3D OTG_STATE_B_HOST;
+					isp->phy.otg->state =3D OTG_STATE_B_HOST;
 					pr_debug("  --> b_host\n");
 					kick =3D 1;
 					break;
 				case OTG_STATE_A_WAIT_BCON:
-					isp->phy.state =3D OTG_STATE_A_HOST;
+					isp->phy.otg->state =3D OTG_STATE_A_HOST;
 					pr_debug("  --> a_host\n");
 					break;
 				case OTG_STATE_A_PERIPHERAL:
-					isp->phy.state =3D OTG_STATE_A_WAIT_BCON;
+					isp->phy.otg->state =3D OTG_STATE_A_WAIT_BCON;
 					pr_debug("  --> a_wait_bcon\n");
 					break;
 				default:
@@ -937,7 +937,7 @@ static void b_peripheral(struct isp1301 *isp)
 	/* UDC driver just set OTG_BSESSVLD */
 	isp1301_set_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLUP);
 	isp1301_clear_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLDOWN);
-	isp->phy.state =3D OTG_STATE_B_PERIPHERAL;
+	isp->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 	pr_debug("  --> b_peripheral\n");
 	dump_regs(isp, "2periph");
 #endif
@@ -947,7 +947,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 {
 	struct usb_otg		*otg =3D isp->phy.otg;
 	u8			isp_stat, isp_bstat;
-	enum usb_otg_state	state =3D isp->phy.state;
+	enum usb_otg_state	state =3D isp->phy.otg->state;
=20
 	if (stat & INTR_BDIS_ACON)
 		pr_debug("OTG:  BDIS_ACON, %s\n", state_name(isp));
@@ -970,7 +970,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				 * when HNP is used.
 				 */
 				if (isp_stat & INTR_VBUS_VLD)
-					isp->phy.state =3D OTG_STATE_A_HOST;
+					isp->phy.otg->state =3D OTG_STATE_A_HOST;
 				break;
 			case OTG_STATE_A_WAIT_VFALL:
 				if (!(isp_stat & INTR_SESS_VLD))
@@ -978,7 +978,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				break;
 			default:
 				if (!(isp_stat & INTR_VBUS_VLD))
-					isp->phy.state =3D OTG_STATE_A_VBUS_ERR;
+					isp->phy.otg->state =3D OTG_STATE_A_VBUS_ERR;
 				break;
 			}
 			isp_bstat =3D isp1301_get_u8(isp, ISP1301_OTG_STATUS);
@@ -1007,7 +1007,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 st=
at)
 		if (otg->default_a) {
 			switch (state) {
 			default:
-				isp->phy.state =3D OTG_STATE_A_WAIT_VFALL;
+				isp->phy.otg->state =3D OTG_STATE_A_WAIT_VFALL;
 				break;
 			case OTG_STATE_A_WAIT_VFALL:
 				state =3D OTG_STATE_A_IDLE;
@@ -1020,7 +1020,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 st=
at)
 				host_suspend(isp);
 				isp1301_clear_bits(isp, ISP1301_MODE_CONTROL_1,
 						MC1_BDIS_ACON_EN);
-				isp->phy.state =3D OTG_STATE_B_IDLE;
+				isp->phy.otg->state =3D OTG_STATE_B_IDLE;
 				l =3D omap_readl(OTG_CTRL) & OTG_CTRL_MASK;
 				l &=3D ~OTG_CTRL_BITS;
 				omap_writel(l, OTG_CTRL);
@@ -1031,7 +1031,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 st=
at)
 		}
 		isp_bstat =3D isp1301_get_u8(isp, ISP1301_OTG_STATUS);
=20
-		switch (isp->phy.state) {
+		switch (isp->phy.otg->state) {
 		case OTG_STATE_B_PERIPHERAL:
 		case OTG_STATE_B_WAIT_ACON:
 		case OTG_STATE_B_HOST:
@@ -1071,7 +1071,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 st=
at)
 		}
 	}
=20
-	if (state !=3D isp->phy.state)
+	if (state !=3D isp->phy.otg->state)
 		pr_debug("  isp, %s -> %s\n",
 				usb_otg_state_string(state), state_name(isp));
=20
@@ -1129,10 +1129,10 @@ isp1301_work(struct work_struct *work)
 			 * skip A_WAIT_VRISE; hc transitions invisibly
 			 * skip A_WAIT_BCON; same.
 			 */
-			switch (isp->phy.state) {
+			switch (isp->phy.otg->state) {
 			case OTG_STATE_A_WAIT_BCON:
 			case OTG_STATE_A_WAIT_VRISE:
-				isp->phy.state =3D OTG_STATE_A_HOST;
+				isp->phy.otg->state =3D OTG_STATE_A_HOST;
 				pr_debug("  --> a_host\n");
 				otg_ctrl =3D omap_readl(OTG_CTRL);
 				otg_ctrl |=3D OTG_A_BUSREQ;
@@ -1141,7 +1141,7 @@ isp1301_work(struct work_struct *work)
 				omap_writel(otg_ctrl, OTG_CTRL);
 				break;
 			case OTG_STATE_B_WAIT_ACON:
-				isp->phy.state =3D OTG_STATE_B_HOST;
+				isp->phy.otg->state =3D OTG_STATE_B_HOST;
 				pr_debug("  --> b_host (acon)\n");
 				break;
 			case OTG_STATE_B_HOST:
@@ -1368,7 +1368,7 @@ isp1301_set_peripheral(struct usb_otg *otg, struct us=
b_gadget *gadget)
 	}
=20
 	power_up(isp);
-	isp->phy.state =3D OTG_STATE_B_IDLE;
+	isp->phy.otg->state =3D OTG_STATE_B_IDLE;
=20
 	if (machine_is_omap_h2() || machine_is_omap_h3())
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
@@ -1403,7 +1403,7 @@ isp1301_set_power(struct usb_phy *dev, unsigned mA)
 {
 	if (!the_transceiver)
 		return -ENODEV;
-	if (dev->state =3D=3D OTG_STATE_B_PERIPHERAL)
+	if (dev->otg->state =3D=3D OTG_STATE_B_PERIPHERAL)
 		enable_vbus_draw(the_transceiver, mA);
 	return 0;
 }
@@ -1414,7 +1414,7 @@ isp1301_start_srp(struct usb_otg *otg)
 	struct isp1301	*isp =3D container_of(otg->phy, struct isp1301, phy);
 	u32		otg_ctrl;
=20
-	if (isp !=3D the_transceiver || isp->phy.state !=3D OTG_STATE_B_IDLE)
+	if (isp !=3D the_transceiver || isp->phy.otg->state !=3D OTG_STATE_B_IDLE)
 		return -ENODEV;
=20
 	otg_ctrl =3D omap_readl(OTG_CTRL);
@@ -1424,7 +1424,7 @@ isp1301_start_srp(struct usb_otg *otg)
 	otg_ctrl |=3D OTG_B_BUSREQ;
 	otg_ctrl &=3D ~OTG_A_BUSREQ & OTG_CTRL_MASK;
 	omap_writel(otg_ctrl, OTG_CTRL);
-	isp->phy.state =3D OTG_STATE_B_SRP_INIT;
+	isp->phy.otg->state =3D OTG_STATE_B_SRP_INIT;
=20
 	pr_debug("otg: SRP, %s ... %06x\n", state_name(isp),
 			omap_readl(OTG_CTRL));
@@ -1452,9 +1452,9 @@ isp1301_start_hnp(struct usb_otg *otg)
 	/* We want hardware to manage most HNP protocol timings.
 	 * So do this part as early as possible...
 	 */
-	switch (isp->phy.state) {
+	switch (isp->phy.otg->state) {
 	case OTG_STATE_B_HOST:
-		isp->phy.state =3D OTG_STATE_B_PERIPHERAL;
+		isp->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 		/* caller will suspend next */
 		break;
 	case OTG_STATE_A_HOST:
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 471e69d..18015b7 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -721,11 +721,11 @@ static int msm_otg_set_host(struct usb_otg *otg, stru=
ct usb_bus *host)
 	}
=20
 	if (!host) {
-		if (otg->phy->state =3D=3D OTG_STATE_A_HOST) {
+		if (otg->state =3D=3D OTG_STATE_A_HOST) {
 			pm_runtime_get_sync(otg->phy->dev);
 			msm_otg_start_host(otg->phy, 0);
 			otg->host =3D NULL;
-			otg->phy->state =3D OTG_STATE_UNDEFINED;
+			otg->state =3D OTG_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->host =3D NULL;
@@ -794,11 +794,11 @@ static int msm_otg_set_peripheral(struct usb_otg *otg,
 	}
=20
 	if (!gadget) {
-		if (otg->phy->state =3D=3D OTG_STATE_B_PERIPHERAL) {
+		if (otg->state =3D=3D OTG_STATE_B_PERIPHERAL) {
 			pm_runtime_get_sync(otg->phy->dev);
 			msm_otg_start_peripheral(otg->phy, 0);
 			otg->gadget =3D NULL;
-			otg->phy->state =3D OTG_STATE_UNDEFINED;
+			otg->state =3D OTG_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->gadget =3D NULL;
@@ -1170,12 +1170,12 @@ static void msm_otg_sm_work(struct work_struct *w)
 	struct msm_otg *motg =3D container_of(w, struct msm_otg, sm_work);
 	struct usb_otg *otg =3D motg->phy.otg;
=20
-	switch (otg->phy->state) {
+	switch (otg->state) {
 	case OTG_STATE_UNDEFINED:
 		dev_dbg(otg->phy->dev, "OTG_STATE_UNDEFINED state\n");
 		msm_otg_reset(otg->phy);
 		msm_otg_init_sm(motg);
-		otg->phy->state =3D OTG_STATE_B_IDLE;
+		otg->state =3D OTG_STATE_B_IDLE;
 		/* FALL THROUGH */
 	case OTG_STATE_B_IDLE:
 		dev_dbg(otg->phy->dev, "OTG_STATE_B_IDLE state\n");
@@ -1183,7 +1183,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 			/* disable BSV bit */
 			writel(readl(USB_OTGSC) & ~OTGSC_BSVIE, USB_OTGSC);
 			msm_otg_start_host(otg->phy, 1);
-			otg->phy->state =3D OTG_STATE_A_HOST;
+			otg->state =3D OTG_STATE_A_HOST;
 		} else if (test_bit(B_SESS_VLD, &motg->inputs)) {
 			switch (motg->chg_state) {
 			case USB_CHG_STATE_UNDEFINED:
@@ -1199,13 +1199,13 @@ static void msm_otg_sm_work(struct work_struct *w)
 					msm_otg_notify_charger(motg,
 							IDEV_CHG_MAX);
 					msm_otg_start_peripheral(otg->phy, 1);
-					otg->phy->state
+					otg->state
 						=3D OTG_STATE_B_PERIPHERAL;
 					break;
 				case USB_SDP_CHARGER:
 					msm_otg_notify_charger(motg, IUNIT);
 					msm_otg_start_peripheral(otg->phy, 1);
-					otg->phy->state
+					otg->state
 						=3D OTG_STATE_B_PERIPHERAL;
 					break;
 				default:
@@ -1230,7 +1230,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 			motg->chg_type =3D USB_INVALID_CHARGER;
 		}
=20
-		if (otg->phy->state =3D=3D OTG_STATE_B_IDLE)
+		if (otg->state =3D=3D OTG_STATE_B_IDLE)
 			pm_runtime_put_sync(otg->phy->dev);
 		break;
 	case OTG_STATE_B_PERIPHERAL:
@@ -1241,7 +1241,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 			msm_otg_start_peripheral(otg->phy, 0);
 			motg->chg_state =3D USB_CHG_STATE_UNDEFINED;
 			motg->chg_type =3D USB_INVALID_CHARGER;
-			otg->phy->state =3D OTG_STATE_B_IDLE;
+			otg->state =3D OTG_STATE_B_IDLE;
 			msm_otg_reset(otg->phy);
 			schedule_work(w);
 		}
@@ -1250,7 +1250,7 @@ static void msm_otg_sm_work(struct work_struct *w)
 		dev_dbg(otg->phy->dev, "OTG_STATE_A_HOST state\n");
 		if (test_bit(ID, &motg->inputs)) {
 			msm_otg_start_host(otg->phy, 0);
-			otg->phy->state =3D OTG_STATE_B_IDLE;
+			otg->state =3D OTG_STATE_B_IDLE;
 			msm_otg_reset(otg->phy);
 			schedule_work(w);
 		}
@@ -1303,7 +1303,7 @@ static int msm_otg_mode_show(struct seq_file *s, void=
 *unused)
 	struct msm_otg *motg =3D s->private;
 	struct usb_otg *otg =3D motg->phy.otg;
=20
-	switch (otg->phy->state) {
+	switch (otg->state) {
 	case OTG_STATE_A_HOST:
 		seq_puts(s, "host\n");
 		break;
@@ -1353,7 +1353,7 @@ static ssize_t msm_otg_mode_write(struct file *file, =
const char __user *ubuf,
=20
 	switch (req_mode) {
 	case USB_DR_MODE_UNKNOWN:
-		switch (otg->phy->state) {
+		switch (otg->state) {
 		case OTG_STATE_A_HOST:
 		case OTG_STATE_B_PERIPHERAL:
 			set_bit(ID, &motg->inputs);
@@ -1364,7 +1364,7 @@ static ssize_t msm_otg_mode_write(struct file *file, =
const char __user *ubuf,
 		}
 		break;
 	case USB_DR_MODE_PERIPHERAL:
-		switch (otg->phy->state) {
+		switch (otg->state) {
 		case OTG_STATE_B_IDLE:
 		case OTG_STATE_A_HOST:
 			set_bit(ID, &motg->inputs);
@@ -1375,7 +1375,7 @@ static ssize_t msm_otg_mode_write(struct file *file, =
const char __user *ubuf,
 		}
 		break;
 	case USB_DR_MODE_HOST:
-		switch (otg->phy->state) {
+		switch (otg->state) {
 		case OTG_STATE_B_IDLE:
 		case OTG_STATE_B_PERIPHERAL:
 			clear_bit(ID, &motg->inputs);
@@ -1769,7 +1769,7 @@ static int msm_otg_runtime_idle(struct device *dev)
 	 * This 1 sec delay also prevents entering into LPM immediately
 	 * after asynchronous interrupt.
 	 */
-	if (otg->phy->state !=3D OTG_STATE_UNDEFINED)
+	if (otg->state !=3D OTG_STATE_UNDEFINED)
 		pm_schedule_suspend(dev, 1000);
=20
 	return -EAGAIN;
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index c9517d8..ee87aa7 100644
--- a/drivers/usb/phy/phy-mv-usb.c
+++ b/drivers/usb/phy/phy-mv-usb.c
@@ -339,68 +339,68 @@ static void mv_otg_update_state(struct mv_otg *mvotg)
 {
 	struct mv_otg_ctrl *otg_ctrl =3D &mvotg->otg_ctrl;
 	struct usb_phy *phy =3D &mvotg->phy;
-	int old_state =3D phy->state;
+	int old_state =3D mvotg->phy.otg->state;
=20
 	switch (old_state) {
 	case OTG_STATE_UNDEFINED:
-		phy->state =3D OTG_STATE_B_IDLE;
+		mvotg->phy.otg->state =3D OTG_STATE_B_IDLE;
 		/* FALL THROUGH */
 	case OTG_STATE_B_IDLE:
 		if (otg_ctrl->id =3D=3D 0)
-			phy->state =3D OTG_STATE_A_IDLE;
+			mvotg->phy.otg->state =3D OTG_STATE_A_IDLE;
 		else if (otg_ctrl->b_sess_vld)
-			phy->state =3D OTG_STATE_B_PERIPHERAL;
+			mvotg->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 		break;
 	case OTG_STATE_B_PERIPHERAL:
 		if (!otg_ctrl->b_sess_vld || otg_ctrl->id =3D=3D 0)
-			phy->state =3D OTG_STATE_B_IDLE;
+			mvotg->phy.otg->state =3D OTG_STATE_B_IDLE;
 		break;
 	case OTG_STATE_A_IDLE:
 		if (otg_ctrl->id)
-			phy->state =3D OTG_STATE_B_IDLE;
+			mvotg->phy.otg->state =3D OTG_STATE_B_IDLE;
 		else if (!(otg_ctrl->a_bus_drop) &&
 			 (otg_ctrl->a_bus_req || otg_ctrl->a_srp_det))
-			phy->state =3D OTG_STATE_A_WAIT_VRISE;
+			mvotg->phy.otg->state =3D OTG_STATE_A_WAIT_VRISE;
 		break;
 	case OTG_STATE_A_WAIT_VRISE:
 		if (otg_ctrl->a_vbus_vld)
-			phy->state =3D OTG_STATE_A_WAIT_BCON;
+			mvotg->phy.otg->state =3D OTG_STATE_A_WAIT_BCON;
 		break;
 	case OTG_STATE_A_WAIT_BCON:
 		if (otg_ctrl->id || otg_ctrl->a_bus_drop
 		    || otg_ctrl->a_wait_bcon_timeout) {
 			mv_otg_cancel_timer(mvotg, A_WAIT_BCON_TIMER);
 			mvotg->otg_ctrl.a_wait_bcon_timeout =3D 0;
-			phy->state =3D OTG_STATE_A_WAIT_VFALL;
+			mvotg->phy.otg->state =3D OTG_STATE_A_WAIT_VFALL;
 			otg_ctrl->a_bus_req =3D 0;
 		} else if (!otg_ctrl->a_vbus_vld) {
 			mv_otg_cancel_timer(mvotg, A_WAIT_BCON_TIMER);
 			mvotg->otg_ctrl.a_wait_bcon_timeout =3D 0;
-			phy->state =3D OTG_STATE_A_VBUS_ERR;
+			mvotg->phy.otg->state =3D OTG_STATE_A_VBUS_ERR;
 		} else if (otg_ctrl->b_conn) {
 			mv_otg_cancel_timer(mvotg, A_WAIT_BCON_TIMER);
 			mvotg->otg_ctrl.a_wait_bcon_timeout =3D 0;
-			phy->state =3D OTG_STATE_A_HOST;
+			mvotg->phy.otg->state =3D OTG_STATE_A_HOST;
 		}
 		break;
 	case OTG_STATE_A_HOST:
 		if (otg_ctrl->id || !otg_ctrl->b_conn
 		    || otg_ctrl->a_bus_drop)
-			phy->state =3D OTG_STATE_A_WAIT_BCON;
+			mvotg->phy.otg->state =3D OTG_STATE_A_WAIT_BCON;
 		else if (!otg_ctrl->a_vbus_vld)
-			phy->state =3D OTG_STATE_A_VBUS_ERR;
+			mvotg->phy.otg->state =3D OTG_STATE_A_VBUS_ERR;
 		break;
 	case OTG_STATE_A_WAIT_VFALL:
 		if (otg_ctrl->id
 		    || (!otg_ctrl->b_conn && otg_ctrl->a_sess_vld)
 		    || otg_ctrl->a_bus_req)
-			phy->state =3D OTG_STATE_A_IDLE;
+			mvotg->phy.otg->state =3D OTG_STATE_A_IDLE;
 		break;
 	case OTG_STATE_A_VBUS_ERR:
 		if (otg_ctrl->id || otg_ctrl->a_clr_err
 		    || otg_ctrl->a_bus_drop) {
 			otg_ctrl->a_clr_err =3D 0;
-			phy->state =3D OTG_STATE_A_WAIT_VFALL;
+			mvotg->phy.otg->state =3D OTG_STATE_A_WAIT_VFALL;
 		}
 		break;
 	default:
@@ -420,8 +420,8 @@ static void mv_otg_work(struct work_struct *work)
 run:
 	/* work queue is single thread, or we need spin_lock to protect */
 	phy =3D &mvotg->phy;
-	otg =3D phy->otg;
-	old_state =3D phy->state;
+	otg =3D mvotg->phy.otg;
+	old_state =3D otg->state;
=20
 	if (!mvotg->active)
 		return;
@@ -429,12 +429,12 @@ run:
 	mv_otg_update_inputs(mvotg);
 	mv_otg_update_state(mvotg);
=20
-	if (old_state !=3D phy->state) {
+	if (old_state !=3D mvotg->phy.otg->state) {
 		dev_info(&mvotg->pdev->dev, "change from state %s to %s\n",
 			 state_string[old_state],
-			 state_string[phy->state]);
+			 state_string[mvotg->phy.otg->state]);
=20
-		switch (phy->state) {
+		switch (mvotg->phy.otg->state) {
 		case OTG_STATE_B_IDLE:
 			otg->default_a =3D 0;
 			if (old_state =3D=3D OTG_STATE_B_PERIPHERAL)
@@ -545,8 +545,8 @@ set_a_bus_req(struct device *dev, struct device_attribu=
te *attr,
 		return -1;
=20
 	/* We will use this interface to change to A device */
-	if (mvotg->phy.state !=3D OTG_STATE_B_IDLE
-	    && mvotg->phy.state !=3D OTG_STATE_A_IDLE)
+	if (mvotg->phy.otg->state !=3D OTG_STATE_B_IDLE
+	    && mvotg->phy.otg->state !=3D OTG_STATE_A_IDLE)
 		return -1;
=20
 	/* The clock may disabled and we need to set irq for ID detected */
@@ -715,9 +715,9 @@ static int mv_otg_probe(struct platform_device *pdev)
 	mvotg->phy.dev =3D &pdev->dev;
 	mvotg->phy.otg =3D otg;
 	mvotg->phy.label =3D driver_name;
-	mvotg->phy.state =3D OTG_STATE_UNDEFINED;
=20
 	otg->phy =3D &mvotg->phy;
+	otg->state =3D OTG_STATE_UNDEFINED;
 	otg->set_host =3D mv_otg_set_host;
 	otg->set_peripheral =3D mv_otg_set_peripheral;
 	otg->set_vbus =3D mv_otg_set_vbus;
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index cc61ee4..04ece53 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -81,33 +81,33 @@ static void check_vbus_state(struct tahvo_usb *tu)
=20
 	reg =3D retu_read(rdev, TAHVO_REG_IDSR);
 	if (reg & TAHVO_STAT_VBUS) {
-		switch (tu->phy.state) {
+		switch (tu->phy.otg->state) {
 		case OTG_STATE_B_IDLE:
 			/* Enable the gadget driver */
 			if (tu->phy.otg->gadget)
 				usb_gadget_vbus_connect(tu->phy.otg->gadget);
-			tu->phy.state =3D OTG_STATE_B_PERIPHERAL;
+			tu->phy.otg->state =3D OTG_STATE_B_PERIPHERAL;
 			break;
 		case OTG_STATE_A_IDLE:
 			/*
 			 * Session is now valid assuming the USB hub is driving
 			 * Vbus.
 			 */
-			tu->phy.state =3D OTG_STATE_A_HOST;
+			tu->phy.otg->state =3D OTG_STATE_A_HOST;
 			break;
 		default:
 			break;
 		}
 		dev_info(&tu->pt_dev->dev, "USB cable connected\n");
 	} else {
-		switch (tu->phy.state) {
+		switch (tu->phy.otg->state) {
 		case OTG_STATE_B_PERIPHERAL:
 			if (tu->phy.otg->gadget)
 				usb_gadget_vbus_disconnect(tu->phy.otg->gadget);
-			tu->phy.state =3D OTG_STATE_B_IDLE;
+			tu->phy.otg->state =3D OTG_STATE_B_IDLE;
 			break;
 		case OTG_STATE_A_HOST:
-			tu->phy.state =3D OTG_STATE_A_IDLE;
+			tu->phy.otg->state =3D OTG_STATE_A_IDLE;
 			break;
 		default:
 			break;
@@ -132,14 +132,14 @@ static void tahvo_usb_become_host(struct tahvo_usb *t=
u)
 	/* Power up the transceiver in USB host mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_REGOUT | USBR_NSUSPEND |
 		   USBR_MASTER_SW2 | USBR_MASTER_SW1);
-	tu->phy.state =3D OTG_STATE_A_IDLE;
+	tu->phy.otg->state =3D OTG_STATE_A_IDLE;
=20
 	check_vbus_state(tu);
 }
=20
 static void tahvo_usb_stop_host(struct tahvo_usb *tu)
 {
-	tu->phy.state =3D OTG_STATE_A_IDLE;
+	tu->phy.otg->state =3D OTG_STATE_A_IDLE;
 }
=20
 static void tahvo_usb_become_peripheral(struct tahvo_usb *tu)
@@ -151,7 +151,7 @@ static void tahvo_usb_become_peripheral(struct tahvo_us=
b *tu)
 	/* Power up transceiver and set it in USB peripheral mode */
 	retu_write(rdev, TAHVO_REG_USBR, USBR_SLAVE_CONTROL | USBR_REGOUT |
 		   USBR_NSUSPEND | USBR_SLAVE_SW);
-	tu->phy.state =3D OTG_STATE_B_IDLE;
+	tu->phy.otg->state =3D OTG_STATE_B_IDLE;
=20
 	check_vbus_state(tu);
 }
@@ -160,7 +160,7 @@ static void tahvo_usb_stop_peripheral(struct tahvo_usb =
*tu)
 {
 	if (tu->phy.otg->gadget)
 		usb_gadget_vbus_disconnect(tu->phy.otg->gadget);
-	tu->phy.state =3D OTG_STATE_B_IDLE;
+	tu->phy.otg->state =3D OTG_STATE_B_IDLE;
 }
=20
 static void tahvo_usb_power_off(struct tahvo_usb *tu)
@@ -173,7 +173,7 @@ static void tahvo_usb_power_off(struct tahvo_usb *tu)
=20
 	/* Power off transceiver */
 	retu_write(rdev, TAHVO_REG_USBR, 0);
-	tu->phy.state =3D OTG_STATE_UNDEFINED;
+	tu->phy.otg->state =3D OTG_STATE_UNDEFINED;
 }
=20
 static int tahvo_usb_set_suspend(struct usb_phy *dev, int suspend)
@@ -379,7 +379,7 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 	/* Create OTG interface */
 	tahvo_usb_power_off(tu);
 	tu->phy.dev =3D &pdev->dev;
-	tu->phy.state =3D OTG_STATE_UNDEFINED;
+	tu->phy.otg->state =3D OTG_STATE_UNDEFINED;
 	tu->phy.label =3D DRIVER_NAME;
 	tu->phy.set_suspend =3D tahvo_usb_set_suspend;
=20
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index 154332b..33d3480 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -18,6 +18,8 @@ struct usb_otg {
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
=20
+	enum usb_otg_state	state;
+
 	/* bind/unbind the host controller */
 	int	(*set_host)(struct usb_otg *otg, struct usb_bus *host);
=20
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 353053a..ac7d791 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -77,7 +77,6 @@ struct usb_phy {
 	unsigned int		 flags;
=20
 	enum usb_phy_type	type;
-	enum usb_otg_state	state;
 	enum usb_phy_events	last_event;
=20
 	struct usb_otg		*otg;

--=20
balbi

--r7U+bLA8boMOj+mD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU5MHAAoJEIaOsuA1yqREyesP/RAgwZBbtDr8tmycPDjlpVH6
Mg+ddNCF6WCQ8WBUA9C4xh0oIjhVDveQCehwHr3BUEyHNzJd3XEjQk1PGhMcCU/D
SpVhGfB93eieBIJj8WSS0f5zSNV4pfhP9oUd6lcn/w7qovRNWuG5ZnoND3aE/pTp
gTTArGgcn8yMAJa7bBwTK4EI0a32pqXylvDvuVBnmq0rG6HCosxhV3AYht8o/2sO
8e0jYZpZyn3h26dTAy2mU209V/Af//iZaqFq4g+JhAWkmTyDqEsf0BZxakMb4sBZ
vGQUNMGnkwgpa4PlM09PJKbCI6/EmNdpnjUZICsoPwW/UWsoAl5pQ+NATP3ISvfU
namqhRm2c/sdmwWB6Pu1Z6En8pcUAiwnt9LdtblVuU+yloLBGSbPprnyK0ZNW6XR
gA1cWtncinWT0PqRcw+Leou6YY9v0qW7tymvldgokc0U+TlJ2eLzgP5inHEjUB7v
jHyIqzQ6SHaP1LgGWVtIGlkR7nAgH5ePj8rLAeveLHwRgO4l268Adq56a0UUuI+H
0tImEVALI2fSrWK3f3+0Js1uvTqVK21P1FHJm4nELmg0/K4T9TLlwgfaFCu+3Lbx
MGOIsz7PNbdFAv4L+JFELPHBGWy1T7gnV/skQYM3dAJDF6r/6s1tTX9x8QfRpGCF
2XzpPUHoFnD8qvN7aUTj
=LvRs
-----END PGP SIGNATURE-----

--r7U+bLA8boMOj+mD--
