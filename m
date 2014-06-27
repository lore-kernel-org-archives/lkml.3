Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaF0KSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:18:20 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:39377 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbaF0KSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <1403823085-10464-2-git-send-email-khoroshilov@ispras.ru>
References: <1403823085-10464-1-git-send-email-khoroshilov@ispras.ru> <1403823085-10464-2-git-send-email-khoroshilov@ispras.ru>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 27 Jun 2014 12:17:37 +0200
Message-ID: <CAOiHx=npgf-YczNVeiZ25Nh8yGeOVvvzT4Hvt2ocL705wexUYQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rsi: fix memory leaks and error handling in rsi_91x_usb
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 12:51 AM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> The patch fixes a couple of issues:
> - absence of deallocation of rsi_dev->rx_usb_urb[0] in the driver;
> - potential NULL pointer dereference because of lack of checks for memory
>   allocation success in rsi_init_usb_interface().
>
> By the way, it makes rsi_probe() returning error code instead of 1
> and fixes comments regarding returning values.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

I count four different issues being fixed, so maybe split this into
four patches?


Regards
Jonas
