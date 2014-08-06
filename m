Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaHFOjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:39:10 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64334 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaHFOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:39:07 -0400
Message-ID: <53E23DFE.7070209@lwfinger.net>
Date: Wed, 06 Aug 2014 09:38:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hans Wennborg <hans@hanshq.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/15] rtlwifi: rtl8192de: fix decimal printf format specifiers
 prefixed with 0x
References: <1407300186-32673-1-git-send-email-hans@hanshq.net>
In-Reply-To: <1407300186-32673-1-git-send-email-hans@hanshq.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 11:43 PM, Hans Wennborg wrote:
> The prefix suggests the number should be printed in hex, so use
> the %x specifier to do that.
> 
> Found by using regex suggested by Joe Perches.
> 
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/net/wireless/rtlwifi/rtl8192de/fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> index 2317707..66e1760 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
> @@ -234,7 +234,7 @@ static int _rtl92d_fw_init(struct ieee80211_hw *hw)
>  			 rtl_read_byte(rtlpriv, FW_MAC1_READY));
>  	}
>  	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
> -		 "Polling FW ready fail!! REG_MCUFWDL:0x%08ul\n",
> +		 "Polling FW ready fail!! REG_MCUFWDL:0x%08lx\n",
>  		 rtl_read_dword(rtlpriv, REG_MCUFWDL));
>  	return -1;
>  }

It would be best to actually build with your patches installed. This one yields
the following warning:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192de/fw.o
drivers/net/wireless/rtlwifi/rtl8192de/fw.c: In function ‘_rtl92d_fw_init’:
drivers/net/wireless/rtlwifi/rtl8192de/fw.c:236:2: warning: format ‘%lx’ expects
argument of type ‘long unsigned int’, but argument 5 has type ‘u32’ [-Wformat=]
  RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
  ^

The format specifier should be %04x, not %08lx. I have no idea why gcc did not
complain as %08ul is also wrong.

Larry

