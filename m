Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbbAAV72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:59:28 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45739 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbbAAV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:59:26 -0500
Date: Thu, 1 Jan 2015 13:59:13 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: kvaser_usb: Don't free packets when tight on URBs
Message-ID: <20150101135913.6205ce0e@urahara>
In-Reply-To: <20141223154654.GB6460@vivalin-002>
References: <20141223154654.GB6460@vivalin-002>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014 17:46:54 +0200
"Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

>  	int ret = NETDEV_TX_OK;
> +	bool kfree_skb_on_error = true;
>  
>  	if (can_dropped_invalid_skb(netdev, skb))
>  		return NETDEV_TX_OK;
> @@ -1336,6 +1337,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
>  
>  	if (!context) {
>  		netdev_warn(netdev, "cannot find free context\n");
> +		kfree_skb_on_error = false;
>  		ret =  NETDEV_TX_BUSY;

You already have a flag value (ret == NETDEV_TX_BUSY), why
not use that instead of introducing another variable?
