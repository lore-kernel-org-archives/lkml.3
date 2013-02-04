Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3BDXls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:41:48 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42036 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab3BDXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:41:45 -0500
Date: Mon, 4 Feb 2013 15:41:35 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, davem@davemloft.net
Message-ID: <1910061949.2175231.1360021295545.JavaMail.root@vmware.com>
In-Reply-To: <510B78E6.3000602@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2681 (ZimbraWebClient - GC24 (Mac)/7.2.0_GA_2681)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> From my side the minimum requirement is to have
> vsock_(un)register_transport calls available, so it is possible to
> write a virtio transport module without having to patch vsock code
> to hook it up.

We've done exactly that.  It's now split into two separate modules,
with the core module offering precisely the calls you've requested.
All transport code is now its own module.  So now you should be
able to add a vsock_transport_virtio module, which can register
with the core.

> >>> +	struct {
> >>> +		/* For DGRAMs. */
> >>> +		struct vmci_handle dg_handle;
> >>
> >> Yep, should be a pointer where transports can hook in their
> >> private
> >> data.
> > 
> > I'm fixing this.
> 
> Yes, please, that is needed too to get started with virtio support.

Fixed: it's now a void * in the core socket structure.

I believe it's now at the point where you can start working on the
virtio transport, and we'll address API issues as they arise and
refine it as necessary.  So please take one last look and let us
know what you think; hopefully we can make the current merge window :)

Thanks!
- Andy
