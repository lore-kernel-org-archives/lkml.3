Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaHKOeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:34:08 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8083 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaHKOeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:34:06 -0400
X-IronPort-AV: E=Sophos;i="5.01,842,1400025600"; 
   d="scan'208";a="161260429"
Date: Mon, 11 Aug 2014 15:32:48 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Scott <Dave.Scott@eu.citrix.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
Subject: Re: [PATCH] xen_hvc: no reason to write the type key on xenstore
In-Reply-To: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1408111532020.2293@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1408111250150.2293@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing tty maintainers.

On Mon, 11 Aug 2014, Stefano Stabellini wrote:
> The backend type is chosen by the toolstack. Regardless, the frontend
> should not care, especially given that it cannot have an effect as the
> backend is started before this code is run.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> index 636c9ba..b8491f5 100644
> --- a/drivers/tty/hvc/hvc_xen.c
> +++ b/drivers/tty/hvc/hvc_xen.c
> @@ -402,9 +402,6 @@ static int xencons_connect_backend(struct xenbus_device *dev,
> 			    evtchn);
> 	if (ret)
> 		goto error_xenbus;
> -	ret = xenbus_printf(xbt, dev->nodename, "type", "ioemu");
> -	if (ret)
> -		goto error_xenbus;
> 	ret = xenbus_transaction_end(xbt, 0);
> 	if (ret) {
> 		if (ret == -EAGAIN)
> 
