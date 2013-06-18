Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3FRE4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:56:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54508 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3FRE4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:56:12 -0400
Date: Tue, 18 Jun 2013 14:55:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernd Bassimir <bassimir.kernel@gmx.de>,
        Nico Doerr <nico.doerr@hawo.net>
Subject: linux-next: manual merge of the staging tree with the usb tree
Message-Id: <20130618145559.cc7923dac280e736c908a422@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_14_55_59_+1000_9sD/ms_5+mdhN2xF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_14_55_59_+1000_9sD/ms_5+mdhN2xF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/serqt_usb2/serqt_usb2.c between commit 1143832eca8f
("USB: serial: ports: add minor and port number") from the usb tree and
commit d68edc2881b1 ("staging: serqt_usb2: Fixed coding style
CamelCases") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/serqt_usb2/serqt_usb2.c
index 880f5c0,39de5e0..0000000
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@@ -870,10 -870,10 +870,10 @@@ static int qt_open(struct tty_struct *t
  	usb_clear_halt(serial->dev, port->read_urb->pipe);
  	port0->open_ports++;
 =20
- 	result =3D qt_get_device(serial, &port0->DeviceData);
+ 	result =3D qt_get_device(serial, &port0->device_data);
 =20
  	/* Port specific setups */
- 	result =3D qt_open_channel(serial, port->port_number, &ChannelData);
 -	result =3D qt_open_channel(serial, port->number, &channel_data);
++	result =3D qt_open_channel(serial, port->port_number, &channel_data);
  	if (result < 0) {
  		dev_dbg(&port->dev, "qt_open_channel failed\n");
  		return result;
@@@ -1239,23 -1245,25 +1239,23 @@@ static void qt_set_termios(struct tty_s
 =20
  	/* Now determine flow control */
  	if (cflag & CRTSCTS) {
 -		dev_dbg(&port->dev, "%s - Enabling HW flow control port %d\n",
 -			__func__, port->number);
 +		dev_dbg(&port->dev, "%s - Enabling HW flow control\n", __func__);
 =20
  		/* Enable RTS/CTS flow control */
- 		status =3D BoxSetHW_FlowCtrl(port->serial, index, 1);
+ 		status =3D box_set_hw_flow_ctrl(port->serial, index, 1);
 =20
  		if (status < 0) {
- 			dev_dbg(&port->dev, "BoxSetHW_FlowCtrl failed\n");
+ 			dev_dbg(&port->dev, "box_set_hw_flow_ctrl failed\n");
  			return;
  		}
  	} else {
  		/* Disable RTS/CTS flow control */
  		dev_dbg(&port->dev,
 -			"%s - disabling HW flow control port %d\n",
 -			__func__, port->number);
 +			"%s - disabling HW flow control\n", __func__);
 =20
- 		status =3D BoxSetHW_FlowCtrl(port->serial, index, 0);
+ 		status =3D box_set_hw_flow_ctrl(port->serial, index, 0);
  		if (status < 0) {
- 			dev_dbg(&port->dev, "BoxSetHW_FlowCtrl failed\n");
+ 			dev_dbg(&port->dev, "box_set_hw_flow_ctrl failed\n");
  			return;
  		}
 =20
@@@ -1324,12 -1332,12 +1324,12 @@@ static inline int qt_real_tiocmget(stru
  	int status;
  	unsigned int index;
 =20
 -	index =3D tty->index - serial->minor;
 +	index =3D port->port_number;
  	status =3D
- 	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
+ 	    box_get_register(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
  	if (status >=3D 0) {
  		status =3D
- 		    BoxGetRegister(port->serial, index,
+ 		    box_get_register(port->serial, index,
  				   MODEM_STATUS_REGISTER, &msr);
 =20
  	}
@@@ -1363,9 -1371,9 +1363,9 @@@ static inline int qt_real_tiocmset(stru
  	int status;
  	unsigned int index;
 =20
 -	index =3D tty->index - serial->minor;
 +	index =3D port->port_number;
  	status =3D
- 	    BoxGetRegister(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
+ 	    box_get_register(port->serial, index, MODEM_CONTROL_REGISTER, &mcr);
  	if (status < 0)
  		return -ESPIPE;
 =20

--Signature=_Tue__18_Jun_2013_14_55_59_+1000_9sD/ms_5+mdhN2xF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRv+hjAAoJEECxmPOUX5FEOF0P/iD7f1soVs8+CAEyQ/R+9fG6
vzm38sQ67iWuxJEj5Xcir2CCQTdrm0jJJDMucvN3EKhPZA5ZkWPmsGqniKRNYEAz
9SnfV2ZuQP4xE/Qzhx0Al/i/Hqh5pj/fLenCTeuo0f84mrXduEp3YF5vBhLiEhno
4efUn66z05zQbUlYX2OSxZtbJf+gaWoH98otU+Gi6/WwQEEfpxkOV6jtjymk1fKf
JFt15yKEbpC2b/57BX8cXxh+4oiuiNdLBqTbRFzXiTxcL5bU/5vaMrg4/39OFI9u
59LMrzZZxsBlsvn87dheihk6HjGJ+VKTez0OZrBOntxTZ+giWwyEqjShJmPQ6pr8
M00A/E159Qudt71Q8LxcHqPIpcKVhZ7QOid+ixO4q9jLQcNjv23eoNKLEtiQrA1y
bIM3C1SETHc63ldjLBlLa809+YRS3L/ELya3Ymhj6x/D9m1VFDUv8QsrMuhGFixa
hsyEKNsdpQ/oAOT/L3uZNUwQSlMB8+t2T/1UYZgcfSvCVYWZfBs5SHuJ54Vh+cEV
MSHwqJlqakioIyEkSs4hsL3qYKSQFflorPJpLMAoCoHFWGSJGO1FD3Yg0VNCX5fk
/3TDIuJhsXC2RpgHVOt/M82WTcTf3aiXztADVcQRUp4HFBH6GwyvECJgece6F53y
lJEUCPBcu6Y+GHnOT3Xc
=Hx75
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_14_55_59_+1000_9sD/ms_5+mdhN2xF--
