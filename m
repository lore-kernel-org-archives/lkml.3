Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbaFTSLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:11:42 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:45428 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaFTSLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:11:41 -0400
Message-ID: <1403287898.30764.17.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] iovec: move memcpy_from/toiovecend to lib/iovec.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        sfr@canb.auug.org.au, hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        stephen@networkplumber.org, sean.hefty@intel.com, fx.lebail@yahoo.com,
        jasowang@redhat.com, hannes@stressinduktion.org,
        wuzhy@linux.vnet.ibm.com, netdev@vger.kernel.org
Date: Fri, 20 Jun 2014 11:11:38 -0700
In-Reply-To: <20140619.210637.1702701955085552032.davem@davemloft.net>
References: <1403201568-22828-1-git-send-email-mst@redhat.com>
	 <20140619.210637.1702701955085552032.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 21:06 -0700, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Thu, 19 Jun 2014 21:22:56 +0300
> 
> > ERROR: "memcpy_fromiovecend" [drivers/vhost/vhost_scsi.ko] undefined!
> > 
> > commit 9f977ef7b671f6169eca78bf40f230fe84b7c7e5
> >     vhost-scsi: Include prot_bytes into expected data transfer length
> > in target-pending makes drivers/vhost/scsi.c call memcpy_fromiovecend().
> > This function is not available when CONFIG_NET is not enabled.
> > 
> > socket.h already includes uio.h, so no callers need updating.
> > 
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > David, could you please ack merging this through
> > target-pending to avoid dependency issues?
> 
> Yep, this looks fine:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Applied to target-pending/queue, and will include in the next PULL
request.

Thanks folks.

--nab

