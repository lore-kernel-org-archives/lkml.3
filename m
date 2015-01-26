Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbbAZSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:02:09 -0500
Received: from mga03.intel.com ([134.134.136.65]:61019 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbbAZSCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:02:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,470,1418112000"; 
   d="scan'208";a="642764951"
Date: Mon, 26 Jan 2015 18:02:04 +0000 (UTC)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.lm.intel.com
To: Christoph Hellwig <hch@infradead.org>
cc: Yan Liu <yan@purestorage.com>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO command
 is being issued via a block device file descriptor
In-Reply-To: <20150125145900.GA15231@infradead.org>
Message-ID: <alpine.LNX.2.00.1501261635190.15481@localhost.lm.intel.com>
References: <1422057426-8014-1-git-send-email-yan@purestorage.com> <20150125145900.GA15231@infradead.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 03:57:06PM -0800, Yan Liu wrote:
>> When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
>> the namespace which is associated with that block device file descriptor. This patch makes such passthrough
>> command ignore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
>> block device descriptor.
>
> This looks good to me.  If Keith can point to a use case for magic or
> hidden nsids we'll have to find a bypass for them, but this certainly
> is the right short term fix:

'Flush' is the only command from the spec where specifying all namespaces
might be desirable. Otherwise, I can't disclose vendor specific behavior
to gain concensus on operating within spec, silly as this desire may
seem. Why empower the driver to make a feature unreachable?
