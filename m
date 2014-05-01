Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaEAPNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:13:09 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52145 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:13:06 -0400
Date: Thu, 1 May 2014 11:13:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/4] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140501151302.GE31611@htj.dyndns.org>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-2-git-send-email-fweisbec@gmail.com>
 <20140424153716.GG14460@htj.dyndns.org>
 <20140501150114.GD25369@localhost.localdomain>
 <20140501150231.GD31611@htj.dyndns.org>
 <20140501150918.GE25369@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501150918.GE25369@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 05:09:20PM +0200, Frederic Weisbecker wrote:
> > > Not sure why you want that. It makes sense on directories grouping
> > > file for different subsystem. But here?
> > 
> > Worried about possible conflicts with workqueue names if we end up
> > with more attributes.
> 
> But they are already protected in their own directories. Also having
> the same file attribute names in root and in individual directories
> suggests that root attributes primes on the childs.

Yeah but workqueues already tend to have pretty short and fundamental
names, and it can get confusing to have mix of files and directories
all with short names without much recognizable pattern.  I don't know.
Maybe I'm worrying too much but I'd really hate to be in a situation
where an attribute has to be renamed because it conflicts with a
workqueue name.

-- 
tejun
