Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaCTPuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:50:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569AbaCTPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:50:38 -0400
Date: Thu, 20 Mar 2014 16:50:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vince@deater.net>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH 4/4] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140320155035.GJ22728@two.firstfloor.org>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
 <1395133004-23205-4-git-send-email-zheng.z.yan@intel.com>
 <alpine.DEB.2.02.1403201059250.8477@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403201059250.8477@pianoman.cluster.toy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I'm not necessarily against the idea, it's just it's tricky enough as it 
> is trying to help people with uncore pmu issues and now I will have to add 
> "make sure the relevant kernel module is loaded" to the list of things 
> that could be going wrong.

In theory the module could be always auto loaded (by adding a
exported pci_device_id to the driver). However for 99% of users it would
be wasted memory, as they never monitor anything.

One way to handle it would be just to add a request_module with
appropiate aliases to perf.

-Andi
