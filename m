Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaK1Wkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:40:49 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:50116 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaK1Wkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <1417213013-19758-1-git-send-email-xerofoify@gmail.com>
References: <1417213013-19758-1-git-send-email-xerofoify@gmail.com>
Date: Fri, 28 Nov 2014 23:40:46 +0100
Message-ID: <CACna6rxmOC0h9hOpa=5iWFM1THQ8Q4hCi8MnmqkZJbB_U0PJ0A@mail.gmail.com>
Subject: Re: [PATCH] drivers:net:wireless: Add mutex locking for function,
 b43_op_beacon_set_time in main.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Nicholas Krause <xerofoify@gmail.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 November 2014 at 23:16, Nicholas Krause <xerofoify@gmail.com> wrote:
> Adds needed mutex lockng  of wl->mutex in order to prevent issues with separate threads executing on
> the b43_update_templates function call in the function, b43_op_beacon_set_time at the same time.

For all kind of kernel documentation / descriptions we try to fit 72
chars limit and we really try to avoid exceeding 80 chars.


> @@ -5094,8 +5094,9 @@ static int b43_op_beacon_set_tim(struct ieee80211_hw *hw,
>  {
>         struct b43_wl *wl = hw_to_b43_wl(hw);
>
> -       /* FIXME: add locking */
> +       mutex_lock(&wl->mutex);
>         b43_update_templates(wl);
> +       mutex_unlock(&wl->mutex);
>
>         return 0;
>  }

Does anyone remember why this simple solution wasn't implemented
earlier? Michael?

Nicholas: did you test it anyhow?
