Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030983AbaLLRMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:12:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030303AbaLLRM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:12:29 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
Date: Fri, 12 Dec 2014 12:12:18 -0500
In-Reply-To: <1418336609-10191-1-git-send-email-kris@konagma.com> (Krzysztof
	Konopko's message of "Thu, 11 Dec 2014 23:23:29 +0100")
Message-ID: <wrfj7fxwyeq5.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Konopko <kris@konagma.com> writes:
> Some struct fields in wifi.h are meant to be __le16 bu were declared as
> unsigned short.  This was reported by sparse:
>
>   rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>   rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>   rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>
> This patch changes declared types of the struct fields involved.
>
> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
> ---
>  drivers/staging/rtl8723au/include/wifi.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
> index fd3da3b..8a2adc5 100644
> --- a/drivers/staging/rtl8723au/include/wifi.h
> +++ b/drivers/staging/rtl8723au/include/wifi.h
> @@ -28,7 +28,7 @@
>  struct AC_param {
>  	unsigned char		ACI_AIFSN;
>  	unsigned char		CW;
> -	unsigned short	TXOP_limit;
> +	__le16			TXOP_limit;
>  }  __packed;
>  
>  struct WMM_para_element {
> @@ -39,9 +39,9 @@ struct WMM_para_element {
>  
>  struct ADDBA_request {
>  	unsigned char		dialog_token;
> -	unsigned short	BA_para_set;
> +	__le16		BA_para_set;
>  	unsigned short	BA_timeout_value;
> -	unsigned short	BA_starting_seqctrl;
> +	__le16		BA_starting_seqctrl;
>  }  __packed;

If you are going to make the struct comply with the on-wire data format,
be consistent. Don't just change half the elements of the struct - that
will just lead to confusion.

Jes
