Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbaDWOXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:23:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47537 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbaDWOXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:23:50 -0400
Date: Wed, 23 Apr 2014 10:23:46 -0400
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
Message-ID: <20140423142346.GB4781@htj.dyndns.org>
References: <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397717444.4034.15.camel@ThinkPad-T5421>
 <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
 <20140421224606.GE22730@htj.dyndns.org>
 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
 <20140422204455.GB3615@mtj.dyndns.org>
 <5356EB6D.3010102@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356EB6D.3010102@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Wed, Apr 23, 2014 at 12:21:33AM +0200, Rafael J. Wysocki wrote:
> Can you please elaborate a bit?

Because it can get involved in larger locking dependency issues by
joining dependency graphs of two otherwise largely disjoint
subsystems.  It has potential to create possible deadlocks which don't
need to exist.

> It is there to protect hotplug operations involving multiple devices
> (in different subsystems) from racing with each other.  Why exactly
> is it bad?

But why would different subsystems, say cpu and memory, use the same
lock?  Wouldn't those subsystems already have proper locking inside
their own subsystems?  Why add this additional global lock across
multiple subsystems?

Thanks.

-- 
tejun
