Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3KOMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:30:40 -0500
Received: from senator.holtmann.net ([87.106.208.187]:53619 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3KOMaW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:30:22 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1384517231-1605-1-git-send-email-geert@linux-m68k.org>
Date: Fri, 15 Nov 2013 21:30:04 +0900
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yu-Chen Cho <acho@suse.com>, devel@driverdev.osuosl.org,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D32EAC93-D2DE-431C-9DCB-885C5AA10A3A@holtmann.org>
References: <1384517231-1605-1-git-send-email-geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> drivers/staging/btmtk_usb/btmtk_usb.c: In function ‘btmtk_usb_probe’:
> drivers/staging/btmtk_usb/btmtk_usb.c:1610: warning: assignment from incompatible pointer type
> 
> Add the new hdev parameter, cfr. commit
> 7bd8f09f69f8a190f9b8334a07bb0a9237612314 ("Bluetooth: Add hdev parameter to
> hdev->send driver callback").
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> drivers/staging/btmtk_usb/btmtk_usb.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
> index 7a9bf3b57810..9a5ebd6cc512 100644
> --- a/drivers/staging/btmtk_usb/btmtk_usb.c
> +++ b/drivers/staging/btmtk_usb/btmtk_usb.c
> @@ -1284,9 +1284,8 @@ done:
> 	kfree_skb(skb);
> }
> 
> -static int btmtk_usb_send_frame(struct sk_buff *skb)
> +static int btmtk_usb_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
> {
> -	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
> 	struct btmtk_usb_data *data = hci_get_drvdata(hdev);
> 	struct usb_ctrlrequest *dr;
> 	struct urb *urb;

while this is patch is correct, I do not really care about staging drivers that actually bluntly violate my copyright.

Regards

Marcel

