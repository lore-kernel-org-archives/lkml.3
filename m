Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbbAVQ6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:58:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:22014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbbAVQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:58:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="516116306"
Date: Thu, 22 Jan 2015 16:58:02 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Christoph Hellwig <hch@infradead.org>
cc: Keith Busch <keith.busch@intel.com>, Yan Liu <yan@purestorage.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <20150122154930.GA28027@infradead.org>
Message-ID: <alpine.LNX.2.00.1501221651410.15481@localhost.lm.intel.com>
References: <1421886503-25276-1-git-send-email-yan@purestorage.com> <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com> <20150122084517.GA2093@infradead.org> <alpine.LNX.2.00.1501221430040.15481@localhost.lm.intel.com>
 <20150122154930.GA28027@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Christoph Hellwig wrote:
> On Thu, Jan 22, 2015 at 03:21:28PM +0000, Keith Busch wrote:
>> But if you really need to restrict namespace access, shouldn't that be
>> enforced on the target side with reservations or similar mechanism?
>
> Think for example about containers where we give eah container access
> to a single nvme namespace, including container root access.  Here you
> don't really want container A to be able to submit I/O for another
> container.  A similar case exists for virtualization where we had
> problems with SCSI passthrough from guests.


Okay, that's a great point.

Yan, we should apply this if you can submit a patch for the linux-block
tree.
