Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaFGXw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:52:58 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40865 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaFGXwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:52:53 -0400
Message-ID: <5393A5D2.2090104@lwfinger.net>
Date: Sat, 07 Jun 2014 18:52:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH linux-next] staging: r8192ee: Adapt flush function prototype
References: <1402162759-17074-1-git-send-email-vincent.stehle@laposte.net>
In-Reply-To: <1402162759-17074-1-git-send-email-vincent.stehle@laposte.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2014 12:39 PM, Vincent Stehlé wrote:
> Commit 77be2c54c5bd 'mac80211: add vif to flush call' modifies the flush
> operation prototype. Update r8192ee function accordingly.
>
> This fixes the following compilation warnings:
>
>    drivers/staging/rtl8192ee/core.c: At top level:
>    drivers/staging/rtl8192ee/core.c:1599:2: warning: initialization from incompatible pointer type [enabled by default]
>      .flush = rtl_op_flush,
>      ^
>    drivers/staging/rtl8192ee/core.c:1599:2: warning: (near initialization for ‘rtl92e_ops.flush’) [enabled by default]
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>

Ah yes, all the "benefits" of adding a new driver in one tree (staging) that 
depends of changes in another (wireless). I have been maintaining this patch in 
my own source for several weeks.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

> ---
>
> Hi,
>
> Linux next gives a "heads up" that the flush function of staging driver r8192ee
> needs to be adapted soon.
>
> This can be seen with e.g. linux next-20140606 and x86 allmodconfig.
>
> Also, r8192ee would benefit from the following patch:
> http://www.spinics.net/lists/linux-driver-devel/msg47690.html
>
> Best regards,
>
> V.
>
>   drivers/staging/rtl8192ee/core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8192ee/core.c b/drivers/staging/rtl8192ee/core.c
> index 76ea356..7f6accd 100644
> --- a/drivers/staging/rtl8192ee/core.c
> +++ b/drivers/staging/rtl8192ee/core.c
> @@ -322,7 +322,7 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
>   	struct rtl_mac *mac = &(rtlpriv->mac80211);
>   	struct cfg80211_pkt_pattern *patterns = wow->patterns;
>   	struct rtl_wow_pattern rtl_pattern;
> -	u8 *pattern_os, *mask_os;
> +	const u8 *pattern_os, *mask_os;
>   	u8 mask[MAX_WOL_BIT_MASK_SIZE] = {0};
>   	u8 content[MAX_WOL_PATTERN_SIZE] = {0};
>   	u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> @@ -1561,7 +1561,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
>    * before switch channle or power save, or tx buffer packet
>    * maybe send after offchannel or rf sleep, this may cause
>    * dis-association by AP */
> -static void rtl_op_flush(struct ieee80211_hw *hw,
> +static void rtl_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>   			 u32 queues, bool drop)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>

