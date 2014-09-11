Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaIKXph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 19:45:37 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43692 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaIKXpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 19:45:36 -0400
Date: Fri, 12 Sep 2014 01:45:31 +0200
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com
Subject: Re: [PATCH RFC 4/4] xen, blkback: add support for multiple block
 rings
Message-ID: <20140911234530.GB2052@gmail.com>
Reply-To: avanzini.arianna@gmail.com
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
 <1408706404-6614-5-git-send-email-avanzini.arianna@gmail.com>
 <53F7428E.90806@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F7428E.90806@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 02:15:58PM +0100, David Vrabel wrote:
> On 22/08/14 12:20, Arianna Avanzini wrote:
> > This commit adds to xen-blkback the support to retrieve the block
> > layer API being used and the number of available hardware queues,
> > in case the block layer is using the multi-queue API. This commit
> > also lets the driver advertise the number of available hardware
> > queues to the frontend via XenStore, therefore allowing for actual
> > multiple I/O rings to be used.
> 
> Does it make sense for number of queues should be dependent on the
> number of queues available in the underlying block device?  

Thank you for raising that point. It probably is not the best solution.

Bob Liu suggested to have the number of I/O rings depend on the number
of vCPUs in the driver domain. Konrad Wilk suggested to compute the
number of I/O rings according to the following formula to preserve the
possibility to explicitly define the number of hardware queues to be
exposed to the frontend:
what_backend_exposes = some_module_parameter ? :
                   min(nr_online_cpus(), nr_hardware_queues()).
io_rings = min(nr_online_cpus(), what_backend_exposes);

(Please do correct me if I misunderstood your point)

> What
> behaviour do we want when a domain is migrated to a host with different
> storage?
> 

This first patchset does not include support to migrate a multi-queue-capable
domU to a host with different storage. The second version, which I am posting
now, includes it. The behavior I have implemented as of now lets the frontend
use the same number of rings, if the backend is still multi-queue-capable
after the migration, otherwise it exposes one only ring.

> Can you split this patch up as well?

Sure, thank you for the comments.

> 
> David

