Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaLWU5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:57:21 -0500
Received: from nm4-vm8.access.bullet.mail.gq1.yahoo.com ([216.39.63.212]:53010
	"EHLO nm4-vm8.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbaLWU5T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:57:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=pacbell.net;
	b=PB9IRyWsd/WIHMEigMbHP8fCVOglh4TG+zcEOpJkwewvof+wahU/u86Ut+R1AsWo6r/Aa/GbrfMpA7nviTg8xImnkcdNU/A5g5yD/UkjHcXGQ5VytDrHsvBbYzsKnXvVzFTsULDUTMoOtUQl9ob+YgB0qr/Zd8gHYy8JlQptOtPcr2380UYROrT/alkrxhFcI2IEEjLhhKThzakV5RU8EqNWblhZM7pn9C31eRd14+dOqTImzaELfOzBp4VHXWPw16l6to1uvykWr+jgzV0wabBpX8KVqRyGkrpMBpWgJPhj0O+69E+guNY5UGCPXy+FzvfDY1NVD6dnpIqQPnjFwQ==;
X-Yahoo-Newman-Id: 900747.55918.bm@smtp114.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _bmNb7QVM1lQyd9P922itrr9U0cspyS1VxmVPAoVqxQIFzh
 qbzLjBXXWpU2JwHPlm89Cgi_KnEa5v3wupADMAtUGTVaG2DlAJBv9cl1YYDy
 s8jk_DsH2M5ZYGCSGuFNS2.uBIzOetG180r.DumkcAP3INaxNSUqXJ.L2iW0
 w1_hPF1ueMrtwfEC0_xUsi0lyU8TFWiX.d33IxnAhhYDpGQZJxg_79OJEGdj
 TkhTlh0p1SmHaDmBhuU7vKf1TLJA7AABJ3RTWS3hZeHyOBVRNptPKy_HPH_y
 BmHh_DkePoD8VFnP0Gvg_POB0LEJJYjtgxWDI5K8.bY0hRQ7dT51yuj1awrc
 SCQaOsMrsKIKMinOM9A0qJCykDo2qcw5sdFE0H7psR.GaIEHq27zOXdCO3GP
 oyS1MR3bAN1dfwc3IBfwF5jUkl2Cnmo8xREIO9TAmJk21vZnC2QYC4YaFONn
 8w63gBvf0E.GhHMeDpHL3JWOcZ9qqucWAqQbef8q5PLMgXpog58I98.1jLsd
 2ynmFJtiuu_lcxlVztzu9Qy9fgLaQQ1vzN02IvW0jxNU53wQfDHWD3Ev7ve_
 GPLCkXznCkNW7wfm3FBCY2Lgoep3OJdOHhtWVwu4TE2_J
X-Yahoo-SMTP: x3UJDw2swBBmiVP7941KaiyaoilgwM.0jf7QxQtKIw--
Message-ID: <5499D72C.7090502@pacbell.net>
Date: Tue, 23 Dec 2014 12:57:16 -0800
From: Richard <richjunk@pacbell.net>
Reply-To: richjunk@pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Kernel 3.17.x Attaching Keyspan 4-Port Serial to USB Adapter
 Causes Kernel Panic
References: <54960F74.1050608@pacbell.net> <20141222175301.GF30375@localhost>
In-Reply-To: <20141222175301.GF30375@localhost>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the same kernel is used (3.17.4), but only the new system oopses?

Yes, using kernel.org's 3.17.4 on both systems, only the new Asus X99-A
based system oopses.  The older Asus P6X58D motherboard, running a very
similarly configured 3.17.4 kernel has no issues with  Keyspan USB adapter.

> This driver is a bit of a mess.
> Could you try the patch below and see if
> it fixes the problem?

Yes.  Thank you.  That fixes the issue.  I can now plug in the Keyspan
USB adapter to my new running system without the kernel freezing.  I
applied your patch to 3.17.7.   I have not yet tried it on 3.18.1.

Using minicom I tested the usb-serial devices and everything seems to work.

Richard



On 12/22/14 09:53, Johan Hovold wrote:
> [+CC: linux-usb ]
> 
> On Sat, Dec 20, 2014 at 04:08:20PM -0800, Richard wrote:
>> On a new Gentoo based system with Kernel.org Kernels 3.17.4 to 3.17.7
>> when I physically plug the Keyspan 4-Port Serial to USB adapter into a
>> usb port my system freezes with a "unable to handle kernel NULL pointer
>> deference" message.
>>
>> My old system (also Gentoo based with Kernel.org 3.17.4) does not have
>> this issue.  Both systems are using the USB_SERIAL_KEYSPAN_USA49W
>> driver module.
> 
> So the same kernel is used (3.17.4), but only the new system oopses?
> 
>> I tried booting into single user mode, using modprobe to load
>> USB_SERIAL_KEYSPAN_USA49W.  lsmod shows the driver.  When I pluged the
>> device in I receive the system freeze.  Below is what I copied off the
>> console ...
>>
>> BUG:  Unable to handle kernel NULL pointer deference at 000...8c
>> IP: [<ffffffffa006fbdd>] usa49_instat_callback+0x4d/0xb0[keyspan]
>> PGD 1037faa067 PUD 1038301067 PMD 0
>> Oops: 0002 [#1] SMP
>> Modules linked in: keyspan ezusb usbserial hid_generic ...
> 
> This driver is a bit of a mess. Could you try the patch below and see if
> it fixes the problem?
> 
> Thanks,
> Johan
> 
> 
>>From 3e98e15094be174d08dc31daab5c7b7791228515 Mon Sep 17 00:00:00 2001
> From: Johan Hovold <johan@kernel.org>
> Date: Mon, 22 Dec 2014 18:39:39 +0100
> Subject: [PATCH] USB: keyspan: fix null-deref at probe
> 
> Fix null-pointer dereference during probe if the interface-status
> completion handler is called before the individual ports have been set
> up.
> 
> Reported-by: Richard <richjunk@pacbell.net>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/usb/serial/keyspan.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
> index 077c714f1285..e07b15ed5814 100644
> --- a/drivers/usb/serial/keyspan.c
> +++ b/drivers/usb/serial/keyspan.c
> @@ -410,6 +410,8 @@ static void	usa26_instat_callback(struct urb *urb)
>  	}
>  	port = serial->port[msg->port];
>  	p_priv = usb_get_serial_port_data(port);
> +	if (!p_priv)
> +		goto resubmit;
>  
>  	/* Update handshaking pin state information */
>  	old_dcd_state = p_priv->dcd_state;
> @@ -420,7 +422,7 @@ static void	usa26_instat_callback(struct urb *urb)
>  
>  	if (old_dcd_state != p_priv->dcd_state)
>  		tty_port_tty_hangup(&port->port, true);
> -
> +resubmit:
>  	/* Resubmit urb so we continue receiving */
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err != 0)
> @@ -527,6 +529,8 @@ static void	usa28_instat_callback(struct urb *urb)
>  	}
>  	port = serial->port[msg->port];
>  	p_priv = usb_get_serial_port_data(port);
> +	if (!p_priv)
> +		goto resubmit;
>  
>  	/* Update handshaking pin state information */
>  	old_dcd_state = p_priv->dcd_state;
> @@ -537,7 +541,7 @@ static void	usa28_instat_callback(struct urb *urb)
>  
>  	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
>  		tty_port_tty_hangup(&port->port, true);
> -
> +resubmit:
>  		/* Resubmit urb so we continue receiving */
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err != 0)
> @@ -607,6 +611,8 @@ static void	usa49_instat_callback(struct urb *urb)
>  	}
>  	port = serial->port[msg->portNumber];
>  	p_priv = usb_get_serial_port_data(port);
> +	if (!p_priv)
> +		goto resubmit;
>  
>  	/* Update handshaking pin state information */
>  	old_dcd_state = p_priv->dcd_state;
> @@ -617,7 +623,7 @@ static void	usa49_instat_callback(struct urb *urb)
>  
>  	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
>  		tty_port_tty_hangup(&port->port, true);
> -
> +resubmit:
>  	/* Resubmit urb so we continue receiving */
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err != 0)
> @@ -855,6 +861,8 @@ static void	usa90_instat_callback(struct urb *urb)
>  
>  	port = serial->port[0];
>  	p_priv = usb_get_serial_port_data(port);
> +	if (!p_priv)
> +		goto resubmit;
>  
>  	/* Update handshaking pin state information */
>  	old_dcd_state = p_priv->dcd_state;
> @@ -865,7 +873,7 @@ static void	usa90_instat_callback(struct urb *urb)
>  
>  	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
>  		tty_port_tty_hangup(&port->port, true);
> -
> +resubmit:
>  	/* Resubmit urb so we continue receiving */
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err != 0)
> @@ -926,6 +934,8 @@ static void	usa67_instat_callback(struct urb *urb)
>  
>  	port = serial->port[msg->port];
>  	p_priv = usb_get_serial_port_data(port);
> +	if (!p_priv)
> +		goto resubmit;
>  
>  	/* Update handshaking pin state information */
>  	old_dcd_state = p_priv->dcd_state;
> @@ -934,7 +944,7 @@ static void	usa67_instat_callback(struct urb *urb)
>  
>  	if (old_dcd_state != p_priv->dcd_state && old_dcd_state)
>  		tty_port_tty_hangup(&port->port, true);
> -
> +resubmit:
>  	/* Resubmit urb so we continue receiving */
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err != 0)
> 
