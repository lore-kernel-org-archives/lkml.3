Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbaLKXxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:53:33 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42495 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaLKXxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:53:32 -0500
Message-ID: <548A2E7A.4010303@lwfinger.net>
Date: Thu, 11 Dec 2014 17:53:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Krzysztof Konopko <kris@konagma.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com>
In-Reply-To: <1418336609-10191-1-git-send-email-kris@konagma.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 04:23 PM, Krzysztof Konopko wrote:
> Some struct fields in wifi.h are meant to be __le16 bu were declared as
> unsigned short.  This was reported by sparse:
>
>    rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>    rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>    rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>
> This patch changes declared types of the struct fields involved.
>
> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
> ---
>   drivers/staging/rtl8723au/include/wifi.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
> index fd3da3b..8a2adc5 100644
> --- a/drivers/staging/rtl8723au/include/wifi.h
> +++ b/drivers/staging/rtl8723au/include/wifi.h
> @@ -28,7 +28,7 @@
>   struct AC_param {
>   	unsigned char		ACI_AIFSN;
>   	unsigned char		CW;
> -	unsigned short	TXOP_limit;
> +	__le16			TXOP_limit;
>   }  __packed;
>
>   struct WMM_para_element {
> @@ -39,9 +39,9 @@ struct WMM_para_element {
>
>   struct ADDBA_request {
>   	unsigned char		dialog_token;
> -	unsigned short	BA_para_set;
> +	__le16		BA_para_set;
>   	unsigned short	BA_timeout_value;
> -	unsigned short	BA_starting_seqctrl;
> +	__le16		BA_starting_seqctrl;
>   }  __packed;

This fix may make the sparse warnings go away, but I think it introduces new 
bugs. In particular, did you test on big-endian hardware after you made this 
change? I recently found that the driver for RTL8188EU needed to have 
BA_para_set to unsigned short, and the endianess warnings needed to be fixed in 
the code. Then it would work on my PowerBook G4 with a PPC processor.

In RTL8188EU, both BA_starting_seqctrl and TXOP_limit are unsigned short.

Larry



