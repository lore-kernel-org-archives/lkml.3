Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaEOU6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:58:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43688 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaEOU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:58:14 -0400
Date: Thu, 15 May 2014 23:57:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/rtl8723au fix sparse warning in os_initfs.c
Message-ID: <20140515205739.GE8897@mwanda>
References: <1400186614-5978-1-git-send-email-bergo.torino@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400186614-5978-1-git-send-email-bergo.torino@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:43:34PM +0200, Konrad Zapalowicz wrote:
> This commit fixes the following sparse warning:
> 
> drivers/staging/rtl8723au/os_dep/os_intfs.c:
>     - 322:14: warning: restricted __be16 degrades to integer
> 
> Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
> ---
>  drivers/staging/rtl8723au/os_dep/os_intfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> index 57eca7a..31a70af 100644
> --- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> @@ -319,7 +319,7 @@ u16 rtw_recv_select_queue23a(struct sk_buff *skb)
>  
>  	memcpy(&eth_type, pdata + (ETH_ALEN << 1), 2);
>  	switch (eth_type) {
> -	case htons(ETH_P_IP):
> +	case be16_to_cpu(htons(ETH_P_IP)):

You should be more careful.  This would have just made the code buggy.

Anyway someone already cleaned up this code.  You should be working
against linux-next.

regards,
dan carpenter

