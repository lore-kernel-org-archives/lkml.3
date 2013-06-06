Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3FFUKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:10:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3FFUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:10:17 -0400
Date: Thu, 6 Jun 2013 16:09:33 -0400
From: Dave Jones <davej@redhat.com>
To: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH] virtio-net: put virtio net header inline
 with data
Message-ID: <20130606200932.GB3837@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jesse Larrew <jlarrew@linux.vnet.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
	Amos Kong <akong@redhat.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
References: <20130606095456.GA7865@redhat.com>
 <51B0EA30.3020804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0EA30.3020804@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 02:59:44PM -0500, Jesse Larrew wrote:
 
 > >  	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
 > > +	if (vi->mergeable_rx_bufs)
 > > +		hdr_len = sizeof hdr->mhdr;
 > > +	else
 > > +		hdr_len = sizeof hdr->hdr;
 > 
 > All conditionals need braces.
 
Documentation/CodingStyle disagrees:

 "Do not unnecessarily use braces where a single statement will do."
 
	Dave 
