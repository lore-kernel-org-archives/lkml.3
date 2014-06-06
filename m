Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaFFKqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:46:47 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43334 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaFFKqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:46:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [RFC] Bluetooth: Do not attempt to send dlci disconnect when in BT_CONFIG.
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1402049971-7762-1-git-send-email-kiran.kumar@linaro.org>
Date: Fri, 6 Jun 2014 12:46:40 +0200
Cc: linux-kernel@vger.kernel.org, Nick Pelly <npelly@google.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Hurley <peter@hurleysoftware.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <02B0CA51-A2BB-47D0-B526-229C12C8195C@holtmann.org>
References: <1402049971-7762-1-git-send-email-kiran.kumar@linaro.org>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kiran,

> Do not attempt to send dlci disconnect when in BT_CONFIG.
> 
> This fixes a bug where shutdown() and close() on a rfcomm socket during ACL
> connection would not cause HCI Create Connection Cancel.
> 
> This is one of the number of patches from the Android AOSP common.git tree,
> which is used on almost all Android devices.  so I wanted to submit it for
> review to see if it should go upstream.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
> Cc: Nick Pelly <npelly@google.com>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Nick Pelly <npelly@google.com>
> [kiran: Added context to commit message]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
> net/bluetooth/rfcomm/core.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index cf62026..6a531e7 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -456,7 +456,6 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
> 
> 	switch (d->state) {
> 	case BT_CONNECT:
> -	case BT_CONFIG:
> 	case BT_OPEN:
> 	case BT_CONNECT2:
> 		if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {

you can include traces and a test program that will demonstrate this behavior. I am hearing about this one for the first time. Nobody else has indicated an issue like this before.

Regards

Marcel

