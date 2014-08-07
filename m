Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaHGVpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:45:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53659 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHGVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:45:41 -0400
Date: Thu, 7 Aug 2014 23:45:32 +0200
From: AdrianRemonda <adrianremonda@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu: Lines over 80 characters fixed.
Message-ID: <20140807214532.GA11670@debian>
References: <1407192303-23519-1-git-send-email-adrianremonda@gmail.com>
 <1407192737.16152.83.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407192737.16152.83.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:52:17PM -0700, Joe Perches wrote:
> On Tue, 2014-08-05 at 00:45 +0200, Adrian Remonda wrote:
> > This is a patch to the hal/rtl8188eu_recv.c file that fixes up a "line
> > over 80 characters" warning found by the checkpatch.pl tool.
> []
> > diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> > index f25c87c..8be4819 100644
> > --- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> > +++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
> > @@ -41,15 +41,19 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
> >  	/* init recv_buf */
> >  	_rtw_init_queue(&precvpriv->free_recv_buf_queue);
> >  
> > -	precvpriv->pallocated_recv_buf = kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
> > +	precvpriv->pallocated_recv_buf =
> > +		kzalloc(NR_RECVBUFF * sizeof(struct recv_buf) + 4, GFP_KERNEL);
> >  	if (precvpriv->pallocated_recv_buf == NULL) {
> >  		res = _FAIL;
> > -		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_, ("alloc recv_buf fail!\n"));
> > +		RT_TRACE(_module_rtl871x_recv_c_, _drv_err_,
> > +				("alloc recv_buf fail!\n"));
> >  		goto exit;
> >  	}
> > -	memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF * sizeof(struct recv_buf) + 4);
> > +	memset(precvpriv->pallocated_recv_buf, 0,
> > +			NR_RECVBUFF * sizeof(struct recv_buf) + 4);
> >  
> > -	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)(precvpriv->pallocated_recv_buf), 4);
> > +	precvpriv->precv_buf = (u8 *)N_BYTE_ALIGMENT((size_t)
> > +			(precvpriv->pallocated_recv_buf), 4);
> 
> Several bits of this are not nice.
> 
> the +4 seems senseless.
> zalloc followed by a memset(,0,) is senseless.
> N_BYTE_ALIGNMENT seems senseless as alloc is
> suitable for any alignmet.
> 
> btw: The merge window is open, please be patient
> with any staging patch during the merge window.

I have resent the changes now. Is this ok? Or should I wait until the merge
window is close?
Also N_BYTE_ALIGNMENT is being used by several files in the 8188, should
I remove this macro?


