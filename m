Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945Ab3DDOeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:34:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761924Ab3DDOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:34:17 -0400
Date: Thu, 4 Apr 2013 07:34:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] workqueue, use default pwq when fail to allocate
 node pwd
Message-ID: <20130404143412.GH9425@htj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
 <1365041143-3088-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365041143-3088-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:05:36AM +0800, Lai Jiangshan wrote:
> When we fail to allocate the node pwq, we can use the default pwq
> for the node.
> 
> Thus we can avoid failure after allocated default pwq, and remove
> some code for failure path.

I don't know about this one.  The reason why we fall back to the
default one during CPU UP/DONW is because we don't want to interfere
with CPU hotplug which doesn't really have much to do with specific
workqueues and shouldn't fail even when things go pretty hairy -
e.g. if the user turned off the screen of his/her phone or a laptop is
thrown into the backpack with lid closed, CPU_DOWNs during suspend
better not fail from memory allocation.

apply_workqueue_attrs() is different.  We *want* to notify the issuer
that something went wrong affnd the action requested couldn't be
fulfilled in full.  We don't want to hide a failure.  It'll show up as
a silent performance degradation that nobody knows why it's happening.

So, nope, doesn't look like a good idea to me.

Thanks.

-- 
tejun
