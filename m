Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaKPNCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 08:02:20 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:62188 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaKPNCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 08:02:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,397,1413270000"; 
   d="scan'208";a="50801358"
Message-ID: <5468A056.9030200@broadcom.com>
Date: Sun, 16 Nov 2014 14:02:14 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@chromium.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Brett Rudley <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] brcmfmac: fix error handling of irq_of_parse_and_map
References: <20141114221221.GA35541@dtor-ws>
In-Reply-To: <20141114221221.GA35541@dtor-ws>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/14 23:12, Dmitry Torokhov wrote:
> Return value of irq_of_parse_and_map() is unsigned int, with 0
> indicating failure, so testing for negative result never works.

Whoops, that is bad. Thanks for catching this. It probably needs to go 
to stable as well for 3.17 kernel.

+Cc: stable@vger.kernel.org # v3.17
+Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Dmitry Torokhov<dtor@chromium.org>
> ---
>
> Not tested, found by casual code inspection.
>
>   drivers/net/wireless/brcm80211/brcmfmac/of.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
> index eb3fce82..c824570 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
> @@ -40,8 +40,8 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
>   		return;
>
>   	irq = irq_of_parse_and_map(np, 0);
> -	if (irq<  0) {
> -		brcmf_err("interrupt could not be mapped: err=%d\n", irq);
> +	if (!irq) {
> +		brcmf_err("interrupt could not be mapped\n");
>   		devm_kfree(dev, sdiodev->pdata);
>   		return;
>   	}

