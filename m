Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaIWJKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:10:15 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49026 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaIWJKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:10:11 -0400
X-IronPort-AV: E=Sophos;i="5.04,578,1406617200"; 
   d="scan'208";a="46504411"
Message-ID: <542138EB.40708@broadcom.com>
Date: Tue, 23 Sep 2014 11:10:03 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: Brett Rudley <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Daniel Kim <dekim@broadcom.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2] brcmfmac: Fix off by one bug in brcmf_count_20mhz_channels()
References: <1411426195-13467-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1411426195-13467-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 00:49, Emil Goode wrote:
> In the brcmf_count_20mhz_channels function we are looping through a list
> of channels received from firmware. Since the index of the first channel
> is 0 the condition leads to an off by one bug. This is causing us to hit
> the WARN_ON_ONCE(1) calls in the brcmu_d11n_decchspec function, which is
> how I discovered the bug.
>
> Introduced by:
> commit b48d891676f756d48b4d0ee131e4a7a5d43ca417
> ("brcmfmac: rework wiphy structure setup")
>

Hi John,

This bug was introduced in 3.17 so can it still go in the wireless tree? 
I verified it applies to wireless/master branch.

Regards,
Arend

> Acked-by: Arend van Spriel<arend@broadcom.com>
> Signed-off-by: Emil Goode<emilgoode@gmail.com>
> ---
> v2: Added Arends "Acked-by" tag.
>
>   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> index 12a60ca..0517687 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
> @@ -4924,7 +4924,7 @@ static void brcmf_count_20mhz_channels(struct brcmf_cfg80211_info *cfg,
>   	struct brcmu_chan ch;
>   	int i;
>
> -	for (i = 0; i<= total; i++) {
> +	for (i = 0; i<  total; i++) {
>   		ch.chspec = (u16)le32_to_cpu(chlist->element[i]);
>   		cfg->d11inf.decchspec(&ch);
>

