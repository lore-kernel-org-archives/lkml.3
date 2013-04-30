Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099Ab3D3R7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:59:31 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:42524 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760692Ab3D3R73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:59:29 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 13:59:29 EDT
Date: Tue, 30 Apr 2013 17:53:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
In-Reply-To: <1367344094.27102.182.camel@schen9-DESK>
Message-ID: <0000013e5c1377c5-49a8fca5-eb04-4e3a-a507-ce3a47fea685-000000@email.amazonses.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com> <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com> <1367339009.27102.174.camel@schen9-DESK>
 <0000013e5bfd1548-a6ef7962-7b00-495b-8e83-d7a08413e165-000000@email.amazonses.com> <1367344094.27102.182.camel@schen9-DESK>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.30-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Tim Chen wrote:

> > And why is it a pointer?
>
> A pointer because the default percpu_counter_batch value could change
> later when cpus come online after we initialize per cpu counter and
> percpu_counter_batch will get computed again in percpu_counter_startup.
> Making it a pointer will make it unnecessary to come back and change the
> batch sizes if we use static batch value and default batch size.

But you will have to dereference the pointer whenever you want the batch
size from the hot path. Looks like it would be better to put the value
there directly. You have a list of percpu counters that can be traversed
to change the batch size.


