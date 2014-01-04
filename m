Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaADWvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 17:51:04 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63439 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaADWvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 17:51:02 -0500
Date: Sat, 4 Jan 2014 17:50:58 -0500
From: Tejun Heo <tj@kernel.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140104225058.GC24306@htj.dyndns.org>
References: <1388781285-18067-1-git-send-email-peter.p.waskiewicz.jr@intel.com>
 <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 04, 2014 at 10:43:00PM +0000, Waskiewicz Jr, Peter P wrote:
> Simply put, when we want to allocate an RMID for monitoring httpd
> traffic, we can create a new child in the subsystem hierarchy, and
> assign the httpd processes to it.  Then the RMID can be assigned to the
> subsystem, and each process inherits that RMID.  So instead of dealing
> with assigning an RMID to each and every process, we can leverage the
> existing cgroup mechanisms for grouping processes and their children to
> a group, and they inherit the RMID.

Here's one thing that I don't get, possibly because I'm not
understanding the processor feature too well.  Why does the processor
have to be aware of the grouping?  ie. why can't it be done
per-process and then aggregated?  Is there something inherent about
the monitored events which requires such peculiarity?  Or is it that
accessing the stats data is noticieably expensive to do per context
switch?

> Please let me know if this is a better explanation, and gives a better
> picture of why we decided to approach the implementation this way.  Also
> note that this feature, Cache QoS Monitoring, is the first in a series
> of Platform QoS Monitoring features that will be coming.  So this isn't
> a one-off feature, so however this first piece gets accepted, we want to
> make sure it's easy to expand and not impact userspace tools repeatedly
> (if possible).

In general, I'm quite strongly opposed against using cgroup as
arbitrary grouping mechanism for anything other than resource control,
especially given that we're moving away from multiple hierarchies.

Thanks.

-- 
tejun
