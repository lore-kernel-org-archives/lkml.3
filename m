Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaJJDV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 23:21:26 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58112 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJJDVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 23:21:24 -0400
Date: Fri, 10 Oct 2014 11:21:16 +0800
From: WANG Chao <wangchao19890207@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Masaru Nomura <massa.nomura@gmail.com>, Peng Tao <bergwolf@gmail.com>,
        Chi Pham <fempsci@gmail.com>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] staging, lustre: fix a sparse error
Message-ID: <20141010032116.GC9352@dhcp-17-37.nay.redhat.com>
References: <1412850311-5727-1-git-send-email-wangchao19890207@gmail.com>
 <20141009122831.GA3300@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009122831.GA3300@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/14 at 05:58pm, Sudip Mukherjee wrote:
> On Thu, Oct 09, 2014 at 06:25:10PM +0800, WANG Chao wrote:
> > This fixes the following sparse error:
> > 
> > drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c:393:9: error:
> > incompatible types in comparison expression (different address spaces)
> > 
> > Signed-off-by: WANG Chao <wangchao19890207@gmail.com>
> > ---
> >  drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> > index 245c9d7..1510594 100644
> > --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> > +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
> > @@ -390,7 +390,7 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
> >  	__u32	csum;
> >  	void	*base;
> >  
> > -	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
> > +	LASSERT((void __force *) tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
> is it ok? are you not just suppressing the sparse error?
> iov_base is void __user *  

I think __user annotation is for no dereferencing in kernel space. In
this case, I think it's fine to override this error by __force. Because
they're pointers with identical target types.

Thanks
WANG Chao
