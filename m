Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980AbaDJSB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:01:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50378 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbaDJSBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:01:25 -0400
Message-ID: <5346DC74.8080701@lwfinger.net>
Date: Thu, 10 Apr 2014 13:01:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] staging: r8723au: Add missing initialization of change_inx
 in sort algorithm
References: <1397152016-31005-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1397152016-31005-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 12:46 PM, Geert Uytterhoeven wrote:
> drivers/staging/rtl8723au/core/rtw_wlan_util.c: In function ‘WMMOnAssocRsp23a’:
> drivers/staging/rtl8723au/core/rtw_wlan_util.c:684: warning: ‘change_inx’ may be used uninitialized in this function
>
> Depending on the uninitialized data on the stack, the array may not be
> sorted correctly.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Geert,

Thanks for this. I wonder why my gcc on x86_64 did not flag this problem.

Larry

>   drivers/staging/rtl8723au/core/rtw_wlan_util.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> index 0dfcfbce3b52..a4361bb93865 100644
> --- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> @@ -681,7 +681,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
>   	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
>
>   	if (pregpriv->wifi_spec == 1) {
> -		u32	j, tmp, change_inx;
> +		u32	j, tmp, change_inx = false;
>
>   		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
>   		for (i = 0; i < 4; i++) {
>

