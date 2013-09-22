Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3IVT4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:56:46 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54639 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3IVT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:56:44 -0400
Message-ID: <523F4B76.80507@cogentembedded.com>
Date: Sun, 22 Sep 2013 23:56:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn, joe@perches.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V2] wireless: rtlwifi: Replace variable with a brake
References: <1379879410-22787-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1379879410-22787-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/22/2013 11:50 PM, Peter Senna Tschudin wrote:

    You have a typo in the subject -- "brake" is a device to stop a vehicle. :-)

> This patch removes the variable continual, and change the while loop
> to break when efuse_data == 0xFF.

> Tested by compilation only.

> CC: Joe Perches <joe@perches.com>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> Changes from V1:
>   - Fix the indetation
>   - Remove remaining } from removed else

> Please ignore the patch:
> [PATCH 12/19] wireless: Change variable type to bool

> And apply this one instead.

> The variable continual was declared as int, but was used as bool. I
> sent previous patch changing the variable type to bool, but Joe Perches
> proposed that removing the variable and adding a brake would be better.

>   drivers/net/wireless/rtlwifi/efuse.c | 18 ++++++++----------
>   1 file changed, 8 insertions(+), 10 deletions(-)

> diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
> index 838a1ed..2aedd9f 100644
> --- a/drivers/net/wireless/rtlwifi/efuse.c
> +++ b/drivers/net/wireless/rtlwifi/efuse.c
> @@ -1203,20 +1203,18 @@ static void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
>
>   static u16 efuse_get_current_size(struct ieee80211_hw *hw)
>   {
> -	int continual = true;
>   	u16 efuse_addr = 0;
>   	u8 hworden;
>   	u8 efuse_data, word_cnts;
>
> -	while (continual && efuse_one_byte_read(hw, efuse_addr, &efuse_data)
> -	       && (efuse_addr < EFUSE_MAX_SIZE)) {
> -		if (efuse_data != 0xFF) {
> -			hworden = efuse_data & 0x0F;
> -			word_cnts = efuse_calculate_word_cnts(hworden);
> -			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
> -		} else {
> -			continual = false;
> -		}
> +	while (efuse_one_byte_read(hw, efuse_addr, &efuse_data) &&
> +					(efuse_addr < EFUSE_MAX_SIZE)) {

    Start this line under efuse_one_byte_read, please. Also, parens are not 
needed.

WBR, Sergei

