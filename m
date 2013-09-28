Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3I1ER5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 00:17:57 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:55462 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab3I1ERz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 00:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <1380340311-4630-1-git-send-email-khoroshilov@ispras.ru>
References: <1380340311-4630-1-git-send-email-khoroshilov@ispras.ru>
Date: Sat, 28 Sep 2013 01:17:54 -0300
Message-ID: <CAOMZO5DE0OdXhWNEr2HAswvgryBqP8VNk3+vanwsi38L6pL9OA@mail.gmail.com>
Subject: Re: [PATCH] carl9170: fix leaks at failure path in carl9170_usb_probe()
From: Fabio Estevam <festevam@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:51 AM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:

> -       return request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
> +       err = request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
>                 &ar->udev->dev, GFP_KERNEL, ar, carl9170_usb_firmware_step2);
> +       if (err) {
> +               usb_put_dev(udev);
> +               usb_put_dev(udev);

You are doing the same free twice.

I guess you meant to also free: usb_put_dev(ar->udev)
