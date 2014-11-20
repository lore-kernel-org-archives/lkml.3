Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaKTQCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:02:06 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40367 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaKTQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:02:04 -0500
Date: Thu, 20 Nov 2014 11:01:59 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 03/10] writeback: move bandwidth related fields from
 backing_dev_info into bdi_writeback
Message-ID: <20141120160159.GG14877@htj.dyndns.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
 <1416299848-22112-4-git-send-email-tj@kernel.org>
 <20141120155253.GH2330@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120155253.GH2330@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:52:53PM +0100, Jan Kara wrote:
> On Tue 18-11-14 03:37:21, Tejun Heo wrote:
...
>   Ok, no problem with this patch but I wonder: When you are moving all the
> dirty limiting logic to bdi_writeback, then how do you plan to interpret
> min/max_ratio in presence of several bdi_writeback structures?

I think the current code is botching it but basic idea is to
distribute all bw controls according to the portion that the specific
wb takes out of the whole bdi.  ie. keep sum of avg_bw of all active
wbs and divide distribute bw params according to that.

Thanks.

-- 
tejun
