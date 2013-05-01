Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340Ab3EAOfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:35:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57562 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab3EAOfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:35:00 -0400
Date: Wed, 1 May 2013 09:34:49 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 8/9] rsxx: Fixes CPU usage issues on RHEL 6 Kernels.
Message-ID: <20130501143449.GB17546@oc6784271780.ibm.com>
References: <20130430200049.GA15930@oc6784271780.ibm.com>
 <20130501114420.GX7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501114420.GX7800@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050114-7182-0000-0000-0000067CEC3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, thanks for the prompt reply.

Also, sorry for my poor explaination skills :)

The RHEL 6.x version of the driver is using the legacy
worqueue create function, 'create_singlethread_workqueue'.
This would cause heavy usage of one CPU if data was being
thrashed pretty hard. So, in order to fix it, workqueues
are now being created with 'create_workqueue' and
synchronization with mutexes.

Thanks,
-Philip Kelleher


On Wed, May 01, 2013 at 01:44:20PM +0200, Jens Axboe wrote:
> On Tue, Apr 30 2013, Philip J. Kelleher wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > 
> > This changes how the driver schedules the work to the
> > workqueue threads. 
> > 
> > Note: This patch is primarily for the Red Hat 6 Kernels.
> 
> You need to properly explain the problem and how it's fixed in the
> changelog. The above really makes the read none the wiser on what the
> issue is.
> 
> -- 
> Jens Axboe
> 

