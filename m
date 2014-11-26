Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaKZN3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:29:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaKZN3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:29:10 -0500
Date: Wed, 26 Nov 2014 15:28:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 24/42] virtio_net: enable v1.0 support
Message-ID: <20141126132852.GB5127@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-25-git-send-email-mst@redhat.com>
 <20141126140857.6ff85e4b.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126140857.6ff85e4b.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 02:08:57PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:43:06 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Now that we have completed 1.0 support, enable it in our driver.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> 
> Hm. The spec states that mac is driver-writable in the legacy case.
> Don't we need to fence writing it in virtnet_set_mac_address() in the
> virtio 1.0 case?

You are right. I'll add a patch to fix that one: we
should return -EOPNOTSUPP unless
	VIRTIO_NET_F_CTRL_MAC_ADDR or
	VERSION_1 is clear and VIRTIO_NET_F_MAC is set.


