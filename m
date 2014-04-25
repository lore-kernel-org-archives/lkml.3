Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaDYM22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:28:28 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:50135 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaDYM2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:28:25 -0400
Date: Fri, 25 Apr 2014 08:28:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
Message-ID: <20140425122822.GA20460@htj.dyndns.org>
References: <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
 <20140421223804.GD22730@htj.dyndns.org>
 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
 <20140422204006.GA3615@mtj.dyndns.org>
 <1398218426.2805.42.camel@ThinkPad-T5421.cn.ibm.com>
 <20140423143940.GD4781@htj.dyndns.org>
 <1398328643.2805.102.camel@ThinkPad-T5421.cn.ibm.com>
 <20140424143208.GB14460@htj.dyndns.org>
 <1398390970.2805.136.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398390970.2805.136.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 09:56:10AM +0800, Li Zhong wrote:
> > A nests cpu subsys mutex under s_active of the online node.  B nests
> > s_active of the online node under the cpu subsys mutex.  What am I
> > missing?
> 
> From the above two chain, I think the problem is cpu_subsys_mutex and
> s_active(online), which is the deadlock we are trying to solve in patch

Yeap, that one was what I was thinking about.

> #2. I seems to me s_active(release) here doesn't have lock issues? 

And your patch doesn't change the situation for online.  Alright,
thanks a lot for the explanation.

-- 
tejun
