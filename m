Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaFXVJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:09:35 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:41552 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaFXVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:09:33 -0400
Date: Tue, 24 Jun 2014 17:09:30 -0400
From: Tejun Heo <tj@kernel.org>
To: shirishpargaonkar@gmail.com
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>
Subject: Re: [PATCH] blkio: Release blkg infrastructure only after last
 policy is deactivated.
Message-ID: <20140624210930.GD14909@htj.dyndns.org>
References: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 23, 2014 at 01:52:25PM -0500, shirishpargaonkar@gmail.com wrote:
> From: Shirish Pargaonkar <spargaonkar@suse.com>
> 
> Release blkg infrastructure only after last policy is deactivated
> (i.e. let blkg_destroy_all() be called only from blkcg_deactivate_policy())
> 
> Otherwise, module can oops because root_blkg gets assigned NULL during
> cleanup and we attempt draining the service queues via root_blkg afterwords.

I'm not sure this fix makes sense.  Cleanup path oopses on an already
freed resource.  How can the solution be not freeing?  Why not simply
make blkcg_drain_queue() bail if the blkgs are all destroyed?  The
whole thing is fully synchronized with the queuelock, right?

Can you please also cc Jens when you post the next iteration?

Thanks.

-- 
tejun
