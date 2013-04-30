Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308Ab3D3Res (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:34:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:59797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761187Ab3D3Rep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:34:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,582,1363158000"; 
   d="scan'208";a="326666380"
Date: Tue, 30 Apr 2013 10:34:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
Message-ID: <20130430173433.GJ19487@tassilo.jf.intel.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
 <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
 <1367339009.27102.174.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367339009.27102.174.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is this for and why does it have that alignmend?
> 
> I was assuming that if batch is frequently referenced, it probably
> should not share a cache line with the counters field.

As long as they are both read-mostly it should be fine to share
(cache line will just be SHARED)

Padding would be only useful if one gets changed regularly.
I don't think that's the case here?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
