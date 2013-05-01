Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554Ab3EAPxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:53:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:59906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761541Ab3EAPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:53:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,589,1363158000"; 
   d="scan'208";a="329645397"
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <51809F8D.3040305@gmail.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
	 <51809F8D.3040305@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 May 2013 08:53:39 -0700
Message-ID: <1367423619.27102.198.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 12:52 +0800, Simon Jeons wrote:
> Hi Tim,
> On 04/30/2013 01:12 AM, Tim Chen wrote:
> > Currently, there is a single, global, variable (percpu_counter_batch) that
> > controls the batch sizes for every 'struct percpu_counter' on the system.
> >
> > However, there are some applications, e.g. memory accounting where it is
> > more appropriate to scale the batch size according to the memory size.
> > This patch adds the infrastructure to be able to change the batch sizes
> > for each individual instance of 'struct percpu_counter'.
> >
> > I have chosen to implement the added field of batch as a pointer
> > (by default point to percpu_counter_batch) instead
> > of a static value.  The reason is the percpu_counter initialization
> > can be called when we only have boot cpu and not all cpus are online.
> 
> What's the meaning of boot cpu? Do you mean cpu 0?
> 

Yes.

