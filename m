Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaILKY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:24:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:5416 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbaILKY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:24:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,512,1406592000"; 
   d="scan'208";a="170889283"
Message-ID: <5412C9C1.8060404@citrix.com>
Date: Fri, 12 Sep 2014 11:24:01 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <avanzini.arianna@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <bob.liu@oracle.com>, <felipe.franciosi@citrix.com>, <axboe@fb.com>
Subject: Re: [PATCH RFC 4/4] xen, blkback: add support for multiple block
 rings
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com> <1408706404-6614-5-git-send-email-avanzini.arianna@gmail.com> <53F7428E.90806@citrix.com> <20140911234530.GB2052@gmail.com>
In-Reply-To: <20140911234530.GB2052@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 00:45, Arianna Avanzini wrote:
> On Fri, Aug 22, 2014 at 02:15:58PM +0100, David Vrabel wrote:
>> What
>> behaviour do we want when a domain is migrated to a host with different
>> storage?
>>
> 
> This first patchset does not include support to migrate a multi-queue-capable
> domU to a host with different storage. The second version, which I am posting
> now, includes it. The behavior I have implemented as of now lets the frontend
> use the same number of rings, if the backend is still multi-queue-capable
> after the migration, otherwise it exposes one only ring.

It would be preferable to allow the number of queues to be renegotiated
on reconnection.  This is what netfront does (but netfront is easier
since it can safely discard any queued packets but blkfront cannot).

If the number of queues is fixed then a maximum number of queues must be
part of the ABI specification.  i.e., all backends must support at least
N queues (even if this is more than its preferred number).

The backend can still hint what its preferred number of queues is, but
this can never be more than the maximum.

David

