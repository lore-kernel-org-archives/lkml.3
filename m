Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbbAVBkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:40:47 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41025 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbAVBkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:40:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M1eDac013744, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: Nicholas Mc Guire <der.herr@hofr.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Keerthimai Janarthanan" <keerthimaipb@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Falzoi <fabio.falzoi84@gmail.com>,
        "Tina Johnson" <tinajohnson.1234@gmail.com>,
        Surya Seetharaman <surya.seetharaman9@gmail.com>
Subject: Re: [PATCH] staging: rts5028: use msecs_to_jiffies for timeouts
Thread-Topic: [PATCH] staging: rts5028: use msecs_to_jiffies for timeouts
Thread-Index: AQHQM7pK0ZLyxQpn5keVKEAMtFX8lpzK2y0A
Date: Thu, 22 Jan 2015 01:40:14 +0000
Message-ID: <54C05500.8050809@realsil.com.cn>
References: <1421652347-8484-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1421652347-8484-1-git-send-email-der.herr@hofr.at>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <A38BDFBAB4F1B94FB8B85618143D0B03@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0M1epm6023874

the title should be 5208.

On 01/19/2015 03:25 PM, Nicholas Mc Guire wrote:
> This is only an API consolidation and should make things more readable
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
>
> Converting milliseconds to jiffies by val * HZ / 1000 is technically
> not wrong but msecs_to_jiffies(val) is the cleaner solution and handles
> corner cases correctly.
>
> This patch was only compile tested with x86_64_defconfig + CONFIG_STAGING=y,
> CONFIG_RTS5208=m
>
> Patch is against 3.19.0-rc4 -next-20150116
>
>   drivers/staging/rts5208/rtsx_transport.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rts5208/rtsx_transport.c b/drivers/staging/rts5208/rtsx_transport.c
> index 756a968..dab1995 100644
> --- a/drivers/staging/rts5208/rtsx_transport.c
> +++ b/drivers/staging/rts5208/rtsx_transport.c
> @@ -271,7 +271,7 @@ int rtsx_send_cmd(struct rtsx_chip *chip, u8 card, int timeout)
>   
>   	/* Wait for TRANS_OK_INT */
>   	timeleft = wait_for_completion_interruptible_timeout(
> -		&trans_done, timeout * HZ / 1000);
> +		&trans_done, msecs_to_jiffies(timeout));
>   	if (timeleft <= 0) {
>   		dev_dbg(rtsx_dev(chip), "chip->int_reg = 0x%x\n",
>   			chip->int_reg);
> @@ -431,7 +431,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
>   	spin_unlock_irq(&rtsx->reg_lock);
>   
>   	timeleft = wait_for_completion_interruptible_timeout(
> -		&trans_done, timeout * HZ / 1000);
> +		&trans_done, msecs_to_jiffies(timeout));
>   	if (timeleft <= 0) {
>   		dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
>   			__func__, __LINE__);
> @@ -455,7 +455,7 @@ static int rtsx_transfer_sglist_adma_partial(struct rtsx_chip *chip, u8 card,
>   		init_completion(&trans_done);
>   		spin_unlock_irq(&rtsx->reg_lock);
>   		timeleft = wait_for_completion_interruptible_timeout(
> -			&trans_done, timeout * HZ / 1000);
> +			&trans_done, msecs_to_jiffies(timeout));
>   		if (timeleft <= 0) {
>   			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
>   				__func__, __LINE__);
> @@ -575,7 +575,7 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
>   		spin_unlock_irq(&rtsx->reg_lock);
>   
>   		timeleft = wait_for_completion_interruptible_timeout(
> -			&trans_done, timeout * HZ / 1000);
> +			&trans_done, msecs_to_jiffies(timeout));
>   		if (timeleft <= 0) {
>   			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
>   				__func__, __LINE__);
> @@ -602,7 +602,7 @@ static int rtsx_transfer_sglist_adma(struct rtsx_chip *chip, u8 card,
>   		init_completion(&trans_done);
>   		spin_unlock_irq(&rtsx->reg_lock);
>   		timeleft = wait_for_completion_interruptible_timeout(
> -			&trans_done, timeout * HZ / 1000);
> +			&trans_done, msecs_to_jiffies(timeout));
>   		if (timeleft <= 0) {
>   			dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
>   				__func__, __LINE__);
> @@ -688,7 +688,7 @@ static int rtsx_transfer_buf(struct rtsx_chip *chip, u8 card, void *buf,
>   
>   	/* Wait for TRANS_OK_INT */
>   	timeleft = wait_for_completion_interruptible_timeout(
> -		&trans_done, timeout * HZ / 1000);
> +		&trans_done, msecs_to_jiffies(timeout));
>   	if (timeleft <= 0) {
>   		dev_dbg(rtsx_dev(chip), "Timeout (%s %d)\n",
>   			__func__, __LINE__);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
