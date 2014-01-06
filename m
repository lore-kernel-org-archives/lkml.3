Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaAFKAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:00:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:37071 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaAFKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:00:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,611,1384300800"; 
   d="scan'208";a="87825660"
Message-ID: <1389002445.13274.23.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 26/38] xen: xenbus: add missing put_device
 call
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Levente Kurusa <levex@linux.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Date: Mon, 6 Jan 2014 10:00:45 +0000
In-Reply-To: <52C56F43.6030804@citrix.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
	 <1387465429-3568-27-git-send-email-levex@linux.com>
	 <52C56F43.6030804@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 13:53 +0000, David Vrabel wrote:
> On 19/12/13 15:03, Levente Kurusa wrote:
> > This is required so that we give up the last reference to the device.
> > 
> > Signed-off-by: Levente Kurusa <levex@linux.com>
> > ---
> >  drivers/xen/xenbus/xenbus_probe.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> > index 3c0a74b..4abb9ee 100644
> > --- a/drivers/xen/xenbus/xenbus_probe.c
> > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > @@ -465,8 +465,10 @@ int xenbus_probe_node(struct xen_bus_type *bus,
> >  
> >  	/* Register with generic device framework. */
> >  	err = device_register(&xendev->dev);
> > -	if (err)
> > +	if (err) {
> > +		put_device(&xendev->dev);
> >  		goto fail;
> > +	}
> >  
> >  	return 0;
> >  fail:
> 
> There is a kfree(xendev) here so this introduces a double-free.

How? put_device doesn't touch xendev itself, does it? It just drops the
ref on the dev member which is not separately dynamically allocated and
so not freed either.

Ian.


