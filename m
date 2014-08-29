Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaH2LVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:21:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45577 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2LVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:21:24 -0400
Date: Fri, 29 Aug 2014 14:21:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: linux-kernel@vger.kernel.org, George Zhang <georgezhang@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] VMCI: integer overflow in vmci_datagram_dispatch()
Message-ID: <20140829112104.GF5071@mwanda>
References: <20140829084256.GA14780@mwanda>
 <5400606B.8010905@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5400606B.8010905@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:13:47PM +0200, walter harms wrote:
> 
> 
> Am 29.08.2014 10:42, schrieb Dan Carpenter:
> > This is untrusted user data from vmci_host_do_send_datagram() so the
> > VMCI_DG_SIZE() macro can have an integer overflow.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
> > index f3cdd90..8226652 100644
> > --- a/drivers/misc/vmw_vmci/vmci_datagram.c
> > +++ b/drivers/misc/vmw_vmci/vmci_datagram.c
> > @@ -328,7 +328,8 @@ int vmci_datagram_dispatch(u32 context_id,
> >  
> >  	BUILD_BUG_ON(sizeof(struct vmci_datagram) != 24);
> >  
> > -	if (VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
> > +	if (dg->payload_size > VMCI_MAX_DG_SIZE ||
> > +	    VMCI_DG_SIZE(dg) > VMCI_MAX_DG_SIZE) {
> >  		pr_devel("Payload (size=%llu bytes) too big to send\n",
> >  			 (unsigned long long)dg->payload_size);
> >  		return VMCI_ERROR_INVALID_ARGS;
> 
> Are your sure about that ">" ? maybe ">=" was intended ?

Yes, I'm sure.  As a rule of thumb, > is used for size comparisons and
>= is used for index comparisons.

regards,
dan carpenter

