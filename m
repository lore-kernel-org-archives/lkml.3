Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbaBQJhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:37:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42944 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBQJhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:37:18 -0500
Message-ID: <5301D843.2080203@pengutronix.de>
Date: Mon, 17 Feb 2014 10:37:07 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-can@vger.kernel.org
CC: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH] can: xilinx CAN controller support.
References: <93c7272e-d8bf-43af-b39b-aaa0e0b70b6f@TX2EHSMHS036.ehs.local>
In-Reply-To: <93c7272e-d8bf-43af-b39b-aaa0e0b70b6f@TX2EHSMHS036.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UsaskUTf9erEdo2oRF9JlsSduPjDf82ad"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UsaskUTf9erEdo2oRF9JlsSduPjDf82ad
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/17/2014 10:23 AM, Kedareswara rao Appana wrote:
> This patch adds xilinx CAN controller support.
> This driver supports both ZYNQ CANPS and Soft IP
> AXI CAN controller.

I just had a quick look at the driver:

[...]

> +/**
> + * xcan_tx_interrupt - Tx Done Isr
> + * @ndev:	net_device pointer
> + */
> +static void xcan_tx_interrupt(struct net_device *ndev)
> +{
> +	struct xcan_priv *priv =3D netdev_priv(ndev);
> +	struct net_device_stats *stats =3D &ndev->stats;
> +
> +	stats->tx_packets++;
> +	while (priv->tx_head - priv->tx_tail > 0) {

Note, there might be still CAN frames in the TX FIFO that have not been
transmitted yet. You have to check your hardware! What to do depends on
how you FIFO is organized.

> +		can_get_echo_skb(ndev, priv->tx_tail %
> +					priv->xcan_echo_skb_max_tx);
> +		priv->tx_tail++;
> +	}
> +
> +	netif_wake_queue(ndev);
> +	can_led_event(ndev, CAN_LED_EVENT_TX);
> +}

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--UsaskUTf9erEdo2oRF9JlsSduPjDf82ad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlMB2EMACgkQjTAFq1RaXHNptACfT2egg0cYFMkxwuIAyeejFvdo
wusAn12WE2FLiigL9dC3gNBZtN1oarKm
=Z+zE
-----END PGP SIGNATURE-----

--UsaskUTf9erEdo2oRF9JlsSduPjDf82ad--
