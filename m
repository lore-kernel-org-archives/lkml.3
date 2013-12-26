Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3LZMrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 07:47:51 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52479 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab3LZMru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 07:47:50 -0500
Message-ID: <52BC2576.3090601@cogentembedded.com>
Date: Thu, 26 Dec 2013 16:47:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3.5 18/19] rtlwifi: slight optimization of addr compare
References: <52BC15EA.2020603@huawei.com>
In-Reply-To: <52BC15EA.2020603@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-12-2013 15:41, Ding Tianhong wrote:

> Use possibly more efficient ether_addr_equal_unaligned
> instead of memcmp.

> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Chaoming Li <chaoming_li@realsil.com.cn>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>   drivers/net/wireless/rtlwifi/cam.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
> index 0e510f7..0276153 100644
> --- a/drivers/net/wireless/rtlwifi/cam.c
> +++ b/drivers/net/wireless/rtlwifi/cam.c
[...]
> @@ -335,7 +335,7 @@ void rtl_cam_del_entry(struct ieee80211_hw *hw, u8 *sta_addr)
>   		addr = rtlpriv->sec.hwsec_cam_sta_addr[i];
>   		bitmap = (rtlpriv->sec.hwsec_cam_bitmap) >> i;
>   		if (((bitmap & BIT(0)) == BIT(0)) &&
> -		    (memcmp(addr, sta_addr, ETH_ALEN) == 0)) {
> +		    (ether_addr_equal_unaligned(addr, sta_addr))) {

    It's pointless to enclose function call in parens, again.

WBR, Sergei

