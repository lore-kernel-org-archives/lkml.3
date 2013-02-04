Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3BDQSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:18:37 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:51397 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3BDQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:18:36 -0500
Date: Mon, 4 Feb 2013 08:18:29 -0800
From: Tejun Heo <tj@kernel.org>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, infinipath <infinipath@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "roland@kernel.org" <roland@kernel.org>
Subject: Re: [PATCH 27/62] infiniband/ipath: convert to idr_alloc()
Message-ID: <20130204161829.GA27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-28-git-send-email-tj@kernel.org>
 <32E1700B9017364D9B60AED9960492BC0D58DDB2@FMSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D58DDB2@FMSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 04, 2013 at 04:15:52PM +0000, Marciniszyn, Mike wrote:
> I tried the branch you indicated in the initial patch cover.
> 
> When run with a qib driver, and ipoib ping of another system produces:
...
> Looks like this is tripping during the arp/neighbour path resolution:
> 
> void idr_preload(gfp_t gfp_mask)
> {
>     /*
>      * Consuming preload buffer from non-process context breaks preload
>      * allocation guarantee.  Disallow usage from those contexts.
>      */
>     WARN_ON_ONCE(in_interrupt()); <------------------------
> 
> Any ideas Roland?

Yeah, firewire had the same problem.  It needs to conditionalize
preload() if !__GFP_WAIT (no point anyway).  Will send update patches
soon.

Thanks.

-- 
tejun
