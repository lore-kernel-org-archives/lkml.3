Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaCFIzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 03:55:18 -0500
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:60072 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCFIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 03:55:16 -0500
Message-ID: <1394096112.26326.1.camel@dubbel>
Subject: Re: [PATCH] Drivers:net:wireless:ti:wl1251: Fixed Sparse invalid
 assignment warning
From: Luca Coelho <luca@coelho.fi>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: linville@tuxdriver.com, pavel@ucw.cz, pali.rohar@gmail.com,
        david.gnedt@davizone.at, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 10:55:12 +0200
In-Reply-To: <1393921132-15950-1-git-send-email-surendra.tux@gmail.com>
References: <1393921132-15950-1-git-send-email-surendra.tux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 00:18 -0800, Surendra Patil wrote:
> Sparse warns about invalid assignment in
> drivers/net/wireless/ti/wl1251/cmd.c:451:42: warning: invalid assignment: |=
> drivers/net/wireless/ti/wl1251/cmd.c:451:42:    left side has type restricted __le16
> drivers/net/wireless/ti/wl1251/cmd.c:451:42:    right side has type int
> Hence type converted right side to __le16.
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/net/wireless/ti/wl1251/cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
> index 223649b..bf1fa18 100644
> --- a/drivers/net/wireless/ti/wl1251/cmd.c
> +++ b/drivers/net/wireless/ti/wl1251/cmd.c
> @@ -448,7 +448,7 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
>  	 * Note: This bug may be caused by the fw's DTIM handling.
>  	 */
>  	if (is_zero_ether_addr(wl->bssid))
> -		cmd->params.scan_options |= WL1251_SCAN_OPT_PRIORITY_HIGH;
> +		cmd->params.scan_options |= cpu_to_le16(WL1251_SCAN_OPT_PRIORITY_HIGH);
>  	cmd->params.num_channels = n_channels;
>  	cmd->params.num_probe_requests = n_probes;
>  	cmd->params.tx_rate = cpu_to_le16(1 << 1); /* 2 Mbps */

AFAIR wl1251 is not really endianess-safe.  I think there are lots of
other places where endianess macros should be added.

Nothing wrong with this patch, I'm just saying that while at it, maybe
someone could take care of all the endianess issues with wl1251? ;)

--
Luca.

