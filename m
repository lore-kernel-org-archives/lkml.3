Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3LRVlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:41:36 -0500
Received: from mail-gg0-f170.google.com ([209.85.161.170]:51474 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3LRVld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:41:33 -0500
Date: Wed, 18 Dec 2013 16:41:28 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
Message-ID: <20131218214128.GB8218@mtj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <4108657.rimrPRbHDY@vostro.rjw.lan>
 <20131218111726.GB3808@htj.dyndns.org>
 <3767261.syB7gLdVqQ@vostro.rjw.lan>
 <20131218213936.GA8218@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218213936.GA8218@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:39:36PM -0500, Tejun Heo wrote:
> Yeah, we can just rip out the whole freezer support and let the
> caller's pm notification hooks implement it by doing
> 
> 	workqueue_set_max_active(wq, 0);
> 	flush_workqueue(wq);

Oops, the above doesn't work but I can trivially add a new interface
for this.  Something which waits for the max_active to drop below the
newly set level before returning.

	workqueue_set_max_active_and_wait(wq, 0);

Thanks.

-- 
tejun
