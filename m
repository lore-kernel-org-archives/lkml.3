Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbbAWRui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:50:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:37474 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbbAWRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:50:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="655590512"
Date: Fri, 23 Jan 2015 17:50:33 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Christoph Hellwig <hch@infradead.org>
cc: Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, Yan Liu <yan@purestorage.com>
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <20150123172745.GA28005@infradead.org>
Message-ID: <alpine.LNX.2.00.1501231737070.15481@localhost.lm.intel.com>
References: <1421971328-5065-1-git-send-email-yan@purestorage.com> <20150123075708.GA17232@infradead.org> <alpine.LNX.2.00.1501231451380.15481@localhost.lm.intel.com> <20150123172745.GA28005@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 04:22:02PM +0000, Keith Busch wrote:
>> The namespace id should be enforced on block devices, but is there a
>> problem allowing arbitrary commands through the management char device?
>> I have a need for a pure passthrough, but the proposed patch requires
>> a matching namespace id all the time.
>>
>> I wrote and tested the one below to override nsid on block devices,
>> but doesn't require a visible namespace through the management device.
>
> Allowing requests to differetn namespaces through the admin interface
> doesn't sound too horrible in general, but I still don't like your patch
> below.  Instead of allocating another queue that allows arbitrary nsids
> we should simply look up the namespace when sent through the admin device,
> and still reject it if the namespace isn't valid.  If a namespaces
> is marked hidden we should still create a device for it in Linux,
> as that whole concept of hiding a namespace is silly.

No argument against removing the hidden attribute handling, but there
are unadvertised NSID's that have special meaning. Like NSID 0xffffffff
means to apply a command to all namespaces. Vendor specific commands
may have other special NSID meanings as well.
