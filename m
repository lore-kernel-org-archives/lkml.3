Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3EFQYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3EFQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:24:08 -0400
Date: Mon, 6 May 2013 12:00:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 29.5/32] blk-throttle: add throtl_qnode for dispatch
 fairness
Message-ID: <20130506160006.GA11731@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130504005044.GF22860@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504005044.GF22860@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 05:50:44PM -0700, Tejun Heo wrote:

[..]
> +	 * qnode_on_self is used when bios are directly queued to this
> +	 * throtl_grp so that local bios compete fairly with bios
> +	 * dispatched from children.  qnode_on_parent is used when bios are
> +	 * dispatched from this throtl_grp into its parent and will compete
> +	 * with the sibling qnode_on_parents and the parent's
> +	 * qnode_on_self.
> +	 */
> +	struct throtl_qnode qnode_on_self;
> +	struct throtl_qnode qnode_on_parent;

Do we need one throtl_qnode for each IO dir (read/write) so that we can
queue up the right direction throtl_node in right sq->queued[rw].

Thanks
Vivek
