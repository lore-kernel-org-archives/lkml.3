Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaHAMLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:11:42 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:51567 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbaHAMLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:11:41 -0400
Message-ID: <1406895098.2110.10.camel@x220>
Subject: Re: [PATCH] staging: rtl8723au: Fix static symbol sparse warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2014 14:11:38 +0200
In-Reply-To: <1406898387-13987-1-git-send-email-cmroliv@gmail.com>
References: <1406898387-13987-1-git-send-email-cmroliv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Aug 2014 12:11:38.0686 (UTC) FILETIME=[BF2DA5E0:01CFAD81]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 14:06 +0100, Miguel Oliveira wrote:
> Fix sparse warning:
> drivers/staging/rtl8723au/core/rtw_efuse.c:579:5: warning: symbol 'efuse_GetCurrentSize23a' was not declared. Should it be static?
> 
> Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
> ---
>  drivers/staging/rtl8723au/include/rtw_efuse.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8723au/include/rtw_efuse.h b/drivers/staging/rtl8723au/include/rtw_efuse.h
> index 07bdc34..304cc71 100644
> --- a/drivers/staging/rtl8723au/include/rtw_efuse.h
> +++ b/drivers/staging/rtl8723au/include/rtw_efuse.h
> @@ -82,6 +82,7 @@ struct pg_pkt_struct {
>  /*------------------------Export global variable----------------------------*/
>  
>  u16	efuse_GetMaxSize23a(struct rtw_adapter *padapter);
> +int	efuse_GetCurrentSize23a(struct rtw_adapter *padapter, u16 *size);
>  int	rtw_efuse_access23a(struct rtw_adapter *padapter, u8 bRead, u16 start_addr, u16 cnts, u8 *data);
>  int	rtw_efuse_map_read23a(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);
>  u8	rtw_efuse_map_write(struct rtw_adapter *padapter, u16 addr, u16 cnts, u8 *data);

This function is never used in current linux-next. So I think it might
as well be dropped.

Note there's also Efuse_GetCurrentSize23a (with an uppercase 'E'). It's
used just once. You could probably submit another patch to remove that
from rtw_efuse.h and make it static in rtw_efuse.c The comment above
that function needs and update too, but maybe it's also OK to drop that
comment.


Paul Bolle

