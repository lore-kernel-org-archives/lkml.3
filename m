Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaHYRvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:51:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaHYRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:51:11 -0400
Date: Mon, 25 Aug 2014 10:50:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>, Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Message-ID: <20140825175029.GA25551@kroah.com>
References: <20140819123655.GC12160@sucs.org>
 <20140825093648.GB5046@mwanda>
 <cf94fd58947d4c5aa6d0d369c1126d7f@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf94fd58947d4c5aa6d0d369c1126d7f@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 05:34:27PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Monday, August 25, 2014 2:37 AM
> > To: Sitsofe Wheeler
> > Cc: KY Srinivasan; Greg Kroah-Hartman; Jason Wang; linux-
> > kernel@vger.kernel.org; David S. Miller; Daniel Borkmann;
> > netdev@vger.kernel.org; devel@linuxdriverproject.org; Haiyang Zhang
> > Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
> > 
> > The code here is:
> > 
> > drivers/hv/channel.c
> >    460          BUG_ON(ret != 0);
> >    461          t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
> >    462          BUG_ON(t == 0);
> > 
> > So it calls BUG_ON() if the teardown takes more than 5 seconds.  It's most
> > likely that there is a race condition somewhere.  It's also possible that it's just
> > taking longer than 5 seconds for some odd reason and the bug would go
> > away if we raised it to 60 seconds.
> > 
> > BUG_ON() after 5 seconds seems like a very aggressive thing.
> 
> Dan,
> 
> I am going to audit all BUG_ON() instances.

Please remove them all, no kernel driver should ever crash the kernel
and not give a user a chance to recover :(

thanks,

greg k-h
