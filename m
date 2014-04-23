Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbaDWQw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:52:58 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:65458 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbaDWQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:52:56 -0400
Date: Wed, 23 Apr 2014 12:52:44 -0400
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 2/2] Use kernfs_break_active_protection() for
 device online store callbacks
Message-ID: <20140423165244.GI4781@htj.dyndns.org>
References: <1397717444.4034.15.camel@ThinkPad-T5421>
 <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
 <1398072230.2755.43.camel@ThinkPad-T5421.cn.ibm.com>
 <20140421224606.GE22730@htj.dyndns.org>
 <1398137679.2805.28.camel@ThinkPad-T5421.cn.ibm.com>
 <20140422204455.GB3615@mtj.dyndns.org>
 <5356EB6D.3010102@intel.com>
 <20140423142346.GB4781@htj.dyndns.org>
 <5357E651.2040400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357E651.2040400@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Wed, Apr 23, 2014 at 06:12:01PM +0200, Rafael J. Wysocki wrote:
> >Why add this additional global lock across multiple subsystems?
> 
> That basically is because of how eject works when it is triggered via ACPI.
> 
> It is signaled for a device at the top of a subtree.  It may be a
> container of some sort and the eject involves everything below that
> device in the ACPI namespace.  That may involve multiple subsystem
> (CPUs, memory, PCI host bridge, etc.).
> 
> We do that in two steps, offline (which can fail) and eject proper
> (which can't fail and makes all of the involved devices go away).
> All that has to be done in one go with respect to the
> sysfs-triggered offline/online and that's why the lock is there.

Ah, okay, so it's actually synchronzing across multiple subsystems.  I
think it definitely calls for more documentation.  The requirement is
pretty unusual after all.

Thanks!

-- 
tejun
