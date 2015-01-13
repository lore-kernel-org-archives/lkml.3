Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbAMGYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:24:41 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60640 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbbAMGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:24:40 -0500
Date: Tue, 13 Jan 2015 11:54:27 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Emrys Bayliss <emrys@paradise.net.nz>, forest@alittletooquiet.net,
        tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113062427.GA8265@sudip-PC>
References: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
 <20150113052312.GA3497@sudip-PC>
 <20150113055817.GA10754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113055817.GA10754@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:58:17PM -0800, Greg KH wrote:
> On Tue, Jan 13, 2015 at 10:53:12AM +0530, Sudip Mukherjee wrote:
> > On Tue, Jan 13, 2015 at 03:51:36AM +1100, Emrys Bayliss wrote:
> > > This patch fixes the following checkpatch.pl error:
> > > rxtx.c:588: WARNING: else is not generally useful after a break or return
> > 
> > was the checkpatch error solved with this change? have you checked?
> > 
> > and the checkpatch is giving error at line 558 and not at 588.
> > 
> > > 
> > > Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> > > ---
> > >  drivers/staging/vt6656/rxtx.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> > > index ea5140a..0cce140 100644
> > > --- a/drivers/staging/vt6656/rxtx.c
> > > +++ b/drivers/staging/vt6656/rxtx.c
> > > @@ -574,8 +574,6 @@ static u16 vnt_fill_cts_head(struct vnt_usb_send_context *tx_context,
> > >  
> > >  		return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
> > >  	}
> > > -
> > > -	return 0;
> > 
> > any reason why this return was removed ?
> 
> Because it's not needed.

yes, it is not needed. but the way Emrys Bayliss has changed the code, then we will get a compiler warning about no return statement.
the code becomes :

if (condition) {
	...
	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);	
} else {
	...
	return vnt_rxtx_datahead_g(tx_context, &buf->data_head);
}

I would have removed that return when the code becomes:

if (condition) {
	...
	return vnt_rxtx_datahead_g_fb(tx_context, &buf->data_head);
}
...
return vnt_rxtx_datahead_g(tx_context, &buf->data_head);


or am i wrong in this ?

sudip
