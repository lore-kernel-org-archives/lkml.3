Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967273Ab3E2X4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:56:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967236Ab3E2X4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:56:01 -0400
Date: Thu, 30 May 2013 02:55:07 +0300
From: Felipe Balbi <balbi@ti.com>
To: Yuan-Hsin Chen <yhchen@faraday-tech.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yuanlmm@gmail.com>
Subject: Re: [PATCH] usb: gadget: add Faraday fotg210_udc driver
Message-ID: <20130529235507.GA23190@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369852310-8687-1-git-send-email-yhchen@faraday-tech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1369852310-8687-1-git-send-email-yhchen@faraday-tech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 29, 2013 at 06:31:50PM +0000, Yuan-Hsin Chen wrote:
> Faraday fotg210 udc driver supports only Bulk transfer so far.
> fotg210 could be configured as an USB2.0 peripheral.
>=20
> This driver is tested with mass storage gadget driver on Faraday
> EVB a369.
>=20
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

Run through checkpatch.pl --strict and fix all errors, warnings and all
checks which make sense.

WARNING: please write a paragraph that describes the config symbol fully
#81: FILE: drivers/usb/gadget/Kconfig:196:
+config USB_FOTG210_UDC

CHECK: braces {} should be used on all arms of this statement
#183: FILE: drivers/usb/gadget/fotg210-udc.c:76:
+	if (ep->epnum) {
[...]
+	} else
[...]

WARNING: line over 80 characters
#190: FILE: drivers/usb/gadget/fotg210-udc.c:83:
+static void fotg210_fifo_ep_mapping(struct fotg210_ep *ep, u32 epnum, u32 =
dir_in)

WARNING: line over 80 characters
#237: FILE: drivers/usb/gadget/fotg210-udc.c:130:
+static void fotg210_set_mps(struct fotg210_ep *ep, u32 epnum, u32 mps, u32=
 dir_in)

WARNING: line over 80 characters
#241: FILE: drivers/usb/gadget/fotg210-udc.c:134:
+	u32 offset =3D dir_in ? FOTG210_INEPMPSR(epnum) : FOTG210_OUTEPMPSR(epnum=
);

WARNING: line over 80 characters
#349: FILE: drivers/usb/gadget/fotg210-udc.c:242:
+static void fotg210_ep_free_request(struct usb_ep *_ep, struct usb_request=
 *_req)

WARNING: Avoid CamelCase: <DMATFNR_ACC_Fn>
#372: FILE: drivers/usb/gadget/fotg210-udc.c:265:
+		value |=3D DMATFNR_ACC_Fn(ep->epnum - 1);

WARNING: line over 80 characters
#418: FILE: drivers/usb/gadget/fotg210-udc.c:311:
+		value =3D ioread32(ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));

WARNING: line over 80 characters
#420: FILE: drivers/usb/gadget/fotg210-udc.c:313:
+		iowrite32(value, ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));

WARNING: line over 80 characters
#441: FILE: drivers/usb/gadget/fotg210-udc.c:334:
+			length =3D ioread32(ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));

WARNING: Avoid CamelCase: <FIBCR_BCFx>
#442: FILE: drivers/usb/gadget/fotg210-udc.c:335:
+			length &=3D FIBCR_BCFx;

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#456: FILE: drivers/usb/gadget/fotg210-udc.c:349:
+		printk(KERN_DEBUG "dma_mapping_error\n");

CHECK: Alignment should match open parenthesis
#461: FILE: drivers/usb/gadget/fotg210-udc.c:354:
+	dma_sync_single_for_device(NULL, d, length,
+			ep->dir_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);

WARNING: line over 80 characters
#476: FILE: drivers/usb/gadget/fotg210-udc.c:369:
+static void fotg210_ep0_queue(struct fotg210_ep *ep, struct fotg210_reques=
t *req)

CHECK: braces {} should be used on all arms of this statement
#483: FILE: drivers/usb/gadget/fotg210-udc.c:376:
+		if (req->req.length) {
[...]
+		} else
[...]

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#486: FILE: drivers/usb/gadget/fotg210-udc.c:379:
+			printk(KERN_DEBUG "%s : req->req.length =3D 0x%x\n",

CHECK: Alignment should match open parenthesis
#487: FILE: drivers/usb/gadget/fotg210-udc.c:380:
+			printk(KERN_DEBUG "%s : req->req.length =3D 0x%x\n",
+				__func__, req->req.length);

CHECK: braces {} should be used on all arms of this statement
#492: FILE: drivers/usb/gadget/fotg210-udc.c:385:
+		if (!req->req.length)
[...]
+		else {
[...]

WARNING: line over 80 characters
#495: FILE: drivers/usb/gadget/fotg210-udc.c:388:
+			u32 value =3D ioread32(ep->fotg210->reg + FOTG210_DMISGR0);

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#680: FILE: drivers/usb/gadget/fotg210-udc.c:573:
+		printk(KERN_DEBUG "    0x%x\n", data);

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#691: FILE: drivers/usb/gadget/fotg210-udc.c:584:
+		printk(KERN_DEBUG "    0x%x\n", data);

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#696: FILE: drivers/usb/gadget/fotg210-udc.c:589:
+		printk(KERN_DEBUG "    0x%x\n", data);

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#702: FILE: drivers/usb/gadget/fotg210-udc.c:595:
+		printk(KERN_DEBUG "    0x%x\n", data);

WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(=
=2E..  to printk(KERN_DEBUG ...
#741: FILE: drivers/usb/gadget/fotg210-udc.c:634:
+	printk(KERN_DEBUG "request error!!\n");

WARNING: line over 80 characters
#744: FILE: drivers/usb/gadget/fotg210-udc.c:637:
+static void fotg210_set_address(struct fotg210_udc *fotg210, struct usb_ct=
rlrequest *ctrl)

WARNING: Avoid CamelCase: <ctrl->wValue>
#746: FILE: drivers/usb/gadget/fotg210-udc.c:639:
+	if (ctrl->wValue >=3D 0x0100)

CHECK: braces {} should be used on all arms of this statement
#746: FILE: drivers/usb/gadget/fotg210-udc.c:639:
+	if (ctrl->wValue >=3D 0x0100)
[...]
+	else {
[...]

WARNING: line over 80 characters
#754: FILE: drivers/usb/gadget/fotg210-udc.c:647:
+static void fotg210_set_feature(struct fotg210_udc *fotg210, struct usb_ct=
rlrequest *ctrl)

WARNING: Avoid CamelCase: <ctrl->bRequestType>
#756: FILE: drivers/usb/gadget/fotg210-udc.c:649:
+	switch (ctrl->bRequestType & USB_RECIP_MASK) {

WARNING: Avoid CamelCase: <ctrl->wIndex>
#765: FILE: drivers/usb/gadget/fotg210-udc.c:658:
+		epnum =3D le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;

WARNING: line over 80 characters
#779: FILE: drivers/usb/gadget/fotg210-udc.c:672:
+static void fotg210_clear_feature(struct fotg210_udc *fotg210, struct usb_=
ctrlrequest *ctrl)

WARNING: line over 80 characters
#821: FILE: drivers/usb/gadget/fotg210-udc.c:714:
+static void fotg210_get_status(struct fotg210_udc *fotg210, struct usb_ctr=
lrequest *ctrl)

WARNING: line over 80 characters
#836: FILE: drivers/usb/gadget/fotg210-udc.c:729:
+				fotg210_is_epnstall(fotg210->ep[epnum]) << USB_ENDPOINT_HALT;

WARNING: line over 80 characters
#854: FILE: drivers/usb/gadget/fotg210-udc.c:747:
+static int fotg210_setup_packet(struct fotg210_udc *fotg210, struct usb_ct=
rlrequest *ctrl)

CHECK: braces {} should be used on all arms of this statement
#870: FILE: drivers/usb/gadget/fotg210-udc.c:763:
+	if ((ctrl->bRequestType & USB_TYPE_MASK) =3D=3D USB_TYPE_STANDARD) {
[...]
+	} else
[...]

WARNING: Avoid CamelCase: <ctrl->bRequest>
#871: FILE: drivers/usb/gadget/fotg210-udc.c:764:
+		switch (ctrl->bRequest) {

CHECK: braces {} should be used on all arms of this statement
#902: FILE: drivers/usb/gadget/fotg210-udc.c:795:
+	if (!list_empty(&ep->queue) && !ep->dir_in) {
[...]
+	} else
[...]

CHECK: braces {} should be used on all arms of this statement
#921: FILE: drivers/usb/gadget/fotg210-udc.c:814:
+	if ((!list_empty(&ep->queue)) && (ep->dir_in)) {
[...]
+	} else
[...]

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#989: FILE: drivers/usb/gadget/fotg210-udc.c:882:
+			printk(KERN_INFO"fotg210 udc reset\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#995: FILE: drivers/usb/gadget/fotg210-udc.c:888:
+			printk(KERN_INFO"fotg210 udc suspend\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1001: FILE: drivers/usb/gadget/fotg210-udc.c:894:
+			printk(KERN_INFO"fotg210 udc resume\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1007: FILE: drivers/usb/gadget/fotg210-udc.c:900:
+			printk(KERN_INFO"fotg210 iso sequence error\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1013: FILE: drivers/usb/gadget/fotg210-udc.c:906:
+			printk(KERN_INFO"fotg210 iso sequence abort\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1020: FILE: drivers/usb/gadget/fotg210-udc.c:913:
+			printk(KERN_INFO"fotg210 transferred 0 byte\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1027: FILE: drivers/usb/gadget/fotg210-udc.c:920:
+			printk(KERN_INFO"fotg210 received 0 byte\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1047: FILE: drivers/usb/gadget/fotg210-udc.c:940:
+			printk(KERN_INFO "fotg210 CX command abort\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1051: FILE: drivers/usb/gadget/fotg210-udc.c:944:
+			printk(KERN_INFO "fotg210 ep0 setup\n");

WARNING: line over 80 characters
#1054: FILE: drivers/usb/gadget/fotg210-udc.c:947:
+				if (fotg210->driver->setup(&fotg210->gadget, &ctrl) < 0)

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1060: FILE: drivers/usb/gadget/fotg210-udc.c:953:
+			printk(KERN_INFO "fotg210 cmd end\n");

WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info=
(...  to printk(KERN_INFO ...
#1070: FILE: drivers/usb/gadget/fotg210-udc.c:963:
+			printk(KERN_INFO "fotg210 ep0 fail\n");

CHECK: Alignment should match open parenthesis
#1129: FILE: drivers/usb/gadget/fotg210-udc.c:1022:
+	iowrite32(GMIR_MHC_INT | GMIR_MOTG_INT | GMIR_INT_POLARITY,
+		fotg210->reg + FOTG210_GMIR);

WARNING: space prohibited before semicolon
#1237: FILE: drivers/usb/gadget/fotg210-udc.c:1130:
+	for (i =3D 0; i < FOTG210_MAX_NUM_EP ; i++) {

CHECK: Alignment should match open parenthesis
#1243: FILE: drivers/usb/gadget/fotg210-udc.c:1136:
+			list_add_tail(&fotg210->ep[i]->ep.ep_list,
+				     &fotg210->gadget.ep_list);

WARNING: kfree(NULL) is safe this check is probably not required
#1291: FILE: drivers/usb/gadget/fotg210-udc.c:1184:
+	if (fotg210)
+		kfree(fotg210);

CHECK: No space is necessary after a cast
#1298: FILE: drivers/usb/gadget/fotg210-udc.c:1191:
+	.driver		=3D {
+		.name =3D	(char *) udc_name,

WARNING: line over 80 characters
#1477: FILE: drivers/usb/gadget/fotg210.h:162:
+#define EPMAP_FIFONO(ep, dir)	((((ep) - 1) << ((ep) - 1) * 8) << ((dir) ? =
0 : 4))

WARNING: line over 80 characters
#1478: FILE: drivers/usb/gadget/fotg210.h:163:
+#define EPMAP_FIFONOMSK(ep, dir)	((3 << ((ep) - 1) * 8) << ((dir) ? 0 : 4))

CHECK: spinlock_t definition without comment
#1549: FILE: drivers/usb/gadget/fotg210.h:234:
+	spinlock_t		lock;

total: 0 errors, 45 warnings, 13 checks, 1472 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

--=20
balbi

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRppVbAAoJEIaOsuA1yqREW0EP/26iQ4gPGc3U64lBwCGoMfvF
tAbWMmDJdmvjSRtegGUKiPRIJaZL+SI7iNIDwkd8dhnvm35FFTkcvHoa7chEAaAq
cx/888FsVbOwO6Thh6FYx7VNuJK6rvt3au8r0T2h6ALZ0RAQq+oEk+Z/gtBZGjFt
6G8eiprO0Q2LXajXqrP+R6JtJ4w489LjG4daLQsy7RbhIKnyUIkKipT2XpIoTmtR
KKXsFnDkLbFfn5AsRfiKbCqqt2xj3SsJuSoUV5+Svfr5Mq75RSSH1B8n7FvZLHcl
QmbULb4dCx2/MATodgraWiXh0qjdRTcEfQGEOzRgS01cvyns8Qk3u+88xhvF/HVo
8cueDSwJ7LO/Xjgz3AdPuOcjxLOhVD6wDg/Zk6Va1QLy0KD9sk/3z0C1KffLGZxw
uWpeiK13kj0O88uobVGHH0QryzFqr3ZfCJhgkulqMw3ioDAPlPNwwui+crmDKI/i
78/vi64lf3GpZ0sXboe+0zt7aXxjxZrXT8mbgGCz0uDl1cLnFrS6NaoXji84mFaw
AVwc9jQ6OVv+nMgXctta5sVs3nuOvC4zmvohhGgLqS6wtF3bvJX0Tm6qID9Wx9kD
3KNPZe4gP93i1V7pRrbzoDIgg5SXmQ4BVon6WvkpnKIZnBKSnJf2u1C4qr9IMel7
jS2fsP1QG2W/8qO78suW
=7h1Q
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
