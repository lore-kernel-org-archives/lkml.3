Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaKMIrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:47:25 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:12090 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbaKMIrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:47:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,375,1413237600"; 
   d="scan'208";a="106531190"
Date: Thu, 13 Nov 2014 09:47:01 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 1/2] staging: rtl8188eu: Deletion of unnecessary checks
 before three function calls
In-Reply-To: <5463C22B.7060405@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411130945151.2389@hadrien>
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <544954FD.8040607@users.sourceforge.net> <20141029084702.GA18675@kroah.com> <5453CD0D.9010206@users.sourceforge.net>
 <alpine.DEB.2.10.1410311900201.2481@hadrien> <5463C10D.6020409@users.sourceforge.net> <5463C22B.7060405@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2014, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 12 Nov 2014 20:25:49 +0100
>
> The functions kfree(), rtw_free_netdev() and vfree() test whether their
> argument is NULL and then return immediately. Thus the test around the call
> is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/staging/rtl8188eu/core/rtw_efuse.c   | 3 +--
>  drivers/staging/rtl8188eu/core/rtw_mlme.c    | 3 +--
>  drivers/staging/rtl8188eu/core/rtw_sta_mgt.c | 3 +--
>  drivers/staging/rtl8188eu/core/rtw_xmit.c    | 6 ++----
>  drivers/staging/rtl8188eu/os_dep/usb_intf.c  | 6 +++---
>  5 files changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
> index 5b997b2..697876b 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
> @@ -212,8 +212,7 @@ efuse_phymap_to_logical(u8 *phymap, u16 _offset, u16 _size_byte, u8  *pbuf)
>  exit:
>  	kfree(efuseTbl);
>
> -	if (eFuseWord)
> -		kfree(eFuseWord);
> +	kfree(eFuseWord);
>  }

As far as I can tell, the 2/2 patch in this series proposes a completely
different fix for this code.  When you send a series, patch n+1/m is
supposed to apply to the result of patch n/m.

In any case, you can let this one go, because the problem has been fixed
already.

julia
