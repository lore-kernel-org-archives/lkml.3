Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbaKURoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:44:21 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:49976 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaKURoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <546F5C01.8060103@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<546F5C01.8060103@users.sourceforge.net>
Date: Fri, 21 Nov 2014 19:44:17 +0200
Message-ID: <CABdoFFeZW_sj5krvx4s03XSv--0jry+4ER_tT2Yt-08RRsoCkQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] USB-IP: Deletion of unnecessary checks before the
 function call "usb_put_dev"
From: Valentina Manea <valentina.manea.m@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 5:36 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 21 Nov 2014 16:33:18 +0100
>
> The usb_put_dev() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/usb/usbip/vhci_hcd.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
> index c02374b..cc1b03e 100644
> --- a/drivers/usb/usbip/vhci_hcd.c
> +++ b/drivers/usb/usbip/vhci_hcd.c
> @@ -518,8 +518,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>                         dev_info(dev, "SetAddress Request (%d) to port %d\n",
>                                  ctrlreq->wValue, vdev->rhport);
>
> -                       if (vdev->udev)
> -                               usb_put_dev(vdev->udev);
> +                       usb_put_dev(vdev->udev);
>                         vdev->udev = usb_get_dev(urb->dev);
>
>                         spin_lock(&vdev->ud.lock);
> @@ -539,8 +538,7 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>                                 usbip_dbg_vhci_hc(
>                                         "Not yet?:Get_Descriptor to device 0 (get max pipe size)\n");
>
> -                       if (vdev->udev)
> -                               usb_put_dev(vdev->udev);
> +                       usb_put_dev(vdev->udev);
>                         vdev->udev = usb_get_dev(urb->dev);
>                         goto out;
>
> @@ -831,8 +829,7 @@ static void vhci_device_reset(struct usbip_device *ud)
>         vdev->speed  = 0;
>         vdev->devid  = 0;
>
> -       if (vdev->udev)
> -               usb_put_dev(vdev->udev);
> +       usb_put_dev(vdev->udev);
>         vdev->udev = NULL;
>
>         if (ud->tcp_socket) {
> --
> 2.1.3
>

Acked-by: Valentina Manea <valentina.manea.m@gmail.com>
