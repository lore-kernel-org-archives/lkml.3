Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbbAZQGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:06:52 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19743 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbbAZQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:06:49 -0500
X-IronPort-AV: E=Sophos;i="5.09,469,1418079600"; 
   d="scan'208";a="118705554"
Date: Mon, 26 Jan 2015 17:06:46 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Julia Lawall <julia.lawall@lip6.fr>
cc: Kumar Amit Mehta <gmate.amit@gmail.com>, gregkh@linuxfoundation.org,
        navin.patidar@gmail.com, Larry.Finger@lwfinger.net,
        dan.carpenter@oracle.com, tapaswenipathak@gmail.com,
        abelmoyo.ab@gmail.com, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: core: rtw_wlan_util.c: Fix for NULL
 dereference
In-Reply-To: <alpine.DEB.2.10.1501261657590.2693@hadrien>
Message-ID: <alpine.DEB.2.10.1501261706170.2693@hadrien>
References: <1422286754-3039-1-git-send-email-gmate.amit@gmail.com> <alpine.DEB.2.10.1501261657590.2693@hadrien>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Jan 2015, Julia Lawall wrote:

> On Mon, 26 Jan 2015, Kumar Amit Mehta wrote:
>
> > In rtw_check_bcn_info(), check the return value of kzalloc() before
> > dereferencing it, to avoid NULL pointer dereference.
> >
> > Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> > ---
> >  drivers/staging/rtl8188eu/core/rtw_wlan_util.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> > index 3e9b6e9..a3ffc69 100644
> > --- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> > +++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
> > @@ -931,6 +931,8 @@ int rtw_check_bcn_info(struct adapter  *Adapter, u8 *pframe, u32 packet_len)
> >  	}
> >
> >  	bssid = kzalloc(sizeof(struct wlan_bssid_ex), GFP_ATOMIC);
> > +	if (!bssid)
> > +		return _FAIL;
>
> I haven't looked at this issue in a while, but shouldn't this be
> OBD_ALLOC?

Sorry for the noise.  I assumed that both patches were for lustre, but
this one is not.

julia
