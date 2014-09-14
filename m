Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaINFyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:54:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:49889 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaINFyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:54:52 -0400
Date: Sun, 14 Sep 2014 07:54:50 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Weird character in kernel message
Message-ID: <20140914055450.GB296@x4>
References: <20140914050905.GA296@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140914050905.GA296@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.09.14 at 07:09 +0200, Markus Trippelsdorf wrote:
> Just noticed this today:
> 
> Sep 14 06:51:57 x4 kernel: [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> 
> in hex:
> 20 01 34 43 45 3A 20
> 
> Must be a recent regression.

It looks like a combination of commit 504d58745c9ca and commit
458df9fd4815b causes the issue.
458df9fd4815b changed the loglevel of printk_deferred to a hardcoded
KERN_WARNING. And 504d58745c9ca changed the printk in
kernel/time/clockevents.c to printk_deferred. 
But now the KERN_WARNING loglevel of printk_deferred in
kernel/time/clockevents.c is redundant and responsible for the weird
01 34 character combination (KERN_SOH "4").

-- 
Markus
