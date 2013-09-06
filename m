Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IFOma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:42:30 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:41409 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3IFOm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:42:28 -0400
Message-ID: <5229E9D2.9060000@lwfinger.net>
Date: Fri, 06 Sep 2013 09:42:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: Fix uninitialized variable change_inx
References: <1378471536-7169-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1378471536-7169-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 07:45 AM, Geert Uytterhoeven wrote:
> drivers/staging/rtl8188eu/core/rtw_wlan_util.c: In function ‘WMMOnAssocRsp’:
> drivers/staging/rtl8188eu/core/rtw_wlan_util.c:634: warning: ‘change_inx’ may be used uninitialized in this function
>
> And the compiler is right: change_inx should be initialized to false.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/staging/rtl8188eu/core/rtw_wlan_util.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> index 013ea48..8018edd 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> @@ -631,7 +631,7 @@ void WMMOnAssocRsp(struct adapter *padapter)
>   	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
>
>   	if (pregpriv->wifi_spec == 1) {
> -		u32	j, tmp, change_inx;
> +		u32	j, tmp, change_inx = false;
>
>   		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
>   		for (i = 0; i < 4; i++) {
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

This warning has not shown up on my x86_64 system with gcc 4.7.2. What 
architecture and gcc version were you using?

Thanks,

Larry

