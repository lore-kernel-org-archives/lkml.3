Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3G3N55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:57:57 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:53500 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3G3N5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:57:55 -0400
Date: Tue, 30 Jul 2013 09:57:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Message-ID: <20130730135751.GD12016@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
 <20130730125306.GC2599@htj.dyndns.org>
 <20130730130708.GA30352@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730130708.GA30352@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 09:07:08PM +0800, Shaohua Li wrote:
> Ok, I should explain here. I can't add a work_struct for each stripe, because
> this will stress workqueue very hard. My system handles > 1M/s stripes, which
> makes workqueue pool lock contended very hard.

It doesn't have to be embedding work_struct in each stripe and
schduling them altogether.  It's more about scheduling "work units"
rather than "workers" - ie. letting each scheduled work item handle
single work unit rather than making it dispatch multiple work items.
It may make controlling concurrency a bit more interesting but you can
always do it with workqueue_set_max_active(), which is the intended
usage anyway.

Thanks.

-- 
tejun
