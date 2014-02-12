Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaBLQzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:55:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaBLQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:55:14 -0500
Date: Wed, 12 Feb 2014 08:56:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        davem@davemloft.net, qinchuanyu@huawei.com,
        Joern Engel <joern@logfs.org>,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
Message-ID: <20140212165630.GA22991@kroah.com>
References: <1392222846-26699-1-git-send-email-mst@redhat.com>
 <1392222846-26699-2-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392222846-26699-2-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 06:38:21PM +0200, Michael S. Tsirkin wrote:
> It is sometimes useful to get the value of the reference count after
> decrement.
> For example, vhost wants to execute some periodic cleanup operations
> once number of references drops below a specific value, before it
> reaches zero (for efficiency).

You should never care about what the value of the kref is, if you are
using it correctly :)

So I really don't want to add this function, as I'm sure people will use
it incorrectly.  You should only care if the reference drops to 0, if
not, then your usage doesn't really fit into the "kref" model, and so,
just use an atomic variable.

I really want to know why it matters for "efficiency" that you know this
number.  How does that help anything, as the number could then go up
later on, and the work you did at a "lower" number is obsolete, right?

thanks,

greg k-h
