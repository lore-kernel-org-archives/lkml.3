Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3CEX2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:28:36 -0500
Received: from mail-gh0-f170.google.com ([209.85.160.170]:35149 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3CEX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:28:34 -0500
Date: Tue, 5 Mar 2013 15:28:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH v2 16/31] workqueue: introduce workqueue_attrs
Message-ID: <20130305232828.GD1227@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-17-git-send-email-tj@kernel.org>
 <20130304183742.GI30413@htj.dyndns.org>
 <513671CF.5050705@gmail.com>
 <20130305223327.GA1227@htj.dyndns.org>
 <20130305223434.GB1227@htj.dyndns.org>
 <51367470.5040909@gmail.com>
 <20130305224444.GC1227@htj.dyndns.org>
 <51367DB4.9080602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51367DB4.9080602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 10:20:20AM +1100, Ryan Mallon wrote:
> I don't get why you would need to separate init/alloc. Nothing in the
> patch series appears to have optional attrs (e.g. a case where attrs

Because workqueue users would want to use workqueue_attrs to specify
attributes and thanks to cpumask_var_t we need alloc interface anyway
and by just allocating the whole thing dynamically we can allow
workqueue_attrs to grow beyond size which is appropriate to allocate
on stack.  Plus, its users are less likely to make mistakes with plain
alloc/free interface than init interface which takes pointer to an
existing object but may fail, which is rather unusual.

Whether the struct itself is dynamic or not just doesn't matter and
it's just easier to have plain alloc/free if there has to be an init
step which may fail.

-- 
tejun
