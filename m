Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaLOPqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:46:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaLOPqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:46:39 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Krzysztof Konopko <kris@konagma.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418452981.29082.7.camel@perches.com>
	<1418655734-32475-1-git-send-email-kris@konagma.com>
Date: Mon, 15 Dec 2014 10:46:28 -0500
In-Reply-To: <1418655734-32475-1-git-send-email-kris@konagma.com> (Krzysztof
	Konopko's message of "Mon, 15 Dec 2014 16:02:14 +0100")
Message-ID: <wrfjfvcgvru3.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Konopko <kris@konagma.com> writes:
> Some struct fields in wifi.h are meant to be __le16 but were declared as
> unsigned short.  This was reported by sparse:
>
>   rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>   rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>   rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>
> This patch updates the types of the fields in `AC_param` and
> `ADDBA_request` structs to be consistent with relevant structs in
> include/linux/ieee80211.h.
>
> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
> ---
>  drivers/staging/rtl8723au/include/wifi.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Well the u8 change is really in the nit picking space, but I am fine
with that too.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
> index fd3da3b..25d573c 100644
> --- a/drivers/staging/rtl8723au/include/wifi.h
> +++ b/drivers/staging/rtl8723au/include/wifi.h
> @@ -26,9 +26,9 @@
>  ------------------------------------------------------------------------------*/
>  
>  struct AC_param {
> -	unsigned char		ACI_AIFSN;
> -	unsigned char		CW;
> -	unsigned short	TXOP_limit;
> +	u8			ACI_AIFSN;
> +	u8			CW;
> +	__le16			TXOP_limit;
>  }  __packed;
>  
>  struct WMM_para_element {
> @@ -38,10 +38,10 @@ struct WMM_para_element {
>  }  __packed;
>  
>  struct ADDBA_request {
> -	unsigned char		dialog_token;
> -	unsigned short	BA_para_set;
> -	unsigned short	BA_timeout_value;
> -	unsigned short	BA_starting_seqctrl;
> +	u8		dialog_token;
> +	__le16		BA_para_set;
> +	__le16		BA_timeout_value;
> +	__le16		BA_starting_seqctrl;
>  }  __packed;
