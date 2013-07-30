Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3G3MrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:47:02 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:37158 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3G3Mq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:46:59 -0400
Date: Tue, 30 Jul 2013 08:46:55 -0400
From: Tejun Heo <tj@kernel.org>
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 3/3] raid5: only wakeup necessary threads
Message-ID: <20130730124655.GB2599@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055425.056034691@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730055425.056034691@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 01:52:10PM +0800, shli@kernel.org wrote:
> If there are no enough stripes to handle, we'd better now always queue all
> available work_structs. If one worker can only handle small or even none
> stripes, it will impact request merge and create lock contention.
> 
> With this patch, the number of work_struct running will depend on pending
> stripes number. Not some statistics info used in the patch are accessed without
> locking protection. Yhis should doesn't matter, we just try best to avoid queue
> unnecessary work_struct.

I haven't really followed the code but two general comments.

* Stacking drivers in general should always try to keep the bios
  passing through in the same order that they are received.  The order
  of bios is an important information to the io scheduler and io
  scheduling will suffer badly if the bios are shuffled by the
  stacking driver.  It'd probably be a good idea to have a mechanism
  to keep the issue order intact even when multiple workers are
  employed.

* While limiting the number of work_struct dynamically could be
  beneficial and it's upto Neil, it'd be nice if you can accompany it
  with some numbers so that whether such optimization actually is
  worthwhile or not can be decided.  The same goes for the whole
  series, I suppose.

Thanks.

-- 
tejun
