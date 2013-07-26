Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3GZKWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:22:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35058 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3GZKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:22:44 -0400
Date: Fri, 26 Jul 2013 06:22:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is
 offline
Message-ID: <20130726102240.GA30786@mtj.dyndns.org>
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
 <20130725153121.GF26107@mtj.dyndns.org>
 <51F1DB45.90905@cn.fujitsu.com>
 <20130726030711.GA30195@mtj.dyndns.org>
 <51F1F138.2060902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1F138.2060902@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 11:47:04AM +0800, Lai Jiangshan wrote:
> any worker can't kill itself.
> managers always tries to leave 2 workers.
> 
> so the workers of the offline cpu pool can't be totally destroyed.

But we *do* want to keep them around as CPUs taken offline are likely
to come online at some point and destroying all of them saves only
~16k of memory while adding more work while CPUs are on/offlined which
can be very frequent on mobile devices.  The change was *intentional*.

Thanks.

-- 
tejun
