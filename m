Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3BUSPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:15:17 -0500
Received: from mx12.netapp.com ([216.240.18.77]:40920 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3BUSPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:15:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,710,1355126400"; 
   d="scan'208";a="24940582"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sunrpc/auth_gss: fix sparse warnings for gss_mech_switch
Thread-Topic: [PATCH] sunrpc/auth_gss: fix sparse warnings for
 gss_mech_switch
Thread-Index: AQHOEF60gAVvS2RhPE2QqqUhTJnkYpiFJBoA
Date: Thu, 21 Feb 2013 18:15:11 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9235DA5BB@SACEXCMBX04-PRD.hq.netapp.com>
References: <1361470206-24116-1-git-send-email-silviupopescu1990@gmail.com>
In-Reply-To: <1361470206-24116-1-git-send-email-silviupopescu1990@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <EB77E0E59E5E93438E89B9D3A559A5F4@tahoe.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 20:10 +0200, Silviu-Mihai Popescu wrote:
> This fixes the following sparse warnings:
> 	* net/sunrpc/auth_gss/gss_mech_switch.c:143:21: warning: symbol
> '_gss_mech_get_by_name' was not declared. Should it be static?
> 	* net/sunrpc/auth_gss/gss_mech_switch.c:208:21: warning: symbol
> '_gss_mech_get_by_pseudoflavor' was not declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
> ---
>  net/sunrpc/auth_gss/gss_mech_switch.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/gss_mech_switch.c b/net/sunrpc/auth_gss/gss_mech_switch.c
> index b174fcd..f0f4eee 100644
> --- a/net/sunrpc/auth_gss/gss_mech_switch.c
> +++ b/net/sunrpc/auth_gss/gss_mech_switch.c
> @@ -140,7 +140,7 @@ gss_mech_get(struct gss_api_mech *gm)
>  
>  EXPORT_SYMBOL_GPL(gss_mech_get);
>  
> -struct gss_api_mech *
> +static struct gss_api_mech *
>  _gss_mech_get_by_name(const char *name)
>  {
>  	struct gss_api_mech	*pos, *gm = NULL;
> @@ -205,7 +205,7 @@ mech_supports_pseudoflavor(struct gss_api_mech *gm, u32 pseudoflavor)
>  	return 0;
>  }
>  
> -struct gss_api_mech *_gss_mech_get_by_pseudoflavor(u32 pseudoflavor)
> +static struct gss_api_mech *_gss_mech_get_by_pseudoflavor(u32 pseudoflavor)
>  {
>  	struct gss_api_mech *gm = NULL, *pos;
>  

This is identical to commit c5f5e9c5d2e9178fb0bfe4f44f0afcc8ad6488ef
(SUNRPC: Add missing static declaration to _gss_mech_get_by_name) which
is already upstream.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
