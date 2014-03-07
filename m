Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaCGP0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:26:48 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:59247 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaCGP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:26:47 -0500
Date: Fri, 7 Mar 2014 10:26:43 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/9] wireless/rt2x00: don't use PREPARE_WORK in
 rt2800usb.c
Message-ID: <20140307152643.GF30778@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929071-16555-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:44:23PM -0500, Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> Update rt2800usb.c to use INIT_WORK() instead of PREPARE_WORK().  As
> the work item isn't in active use during rt2800usb_probe_hw(), this
> doesn't cause any behavior difference.
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: linux-wireless@vger.kernel.org

Applied to wq/for-3.15.  Please holler if there's any objection.

Thanks.

-- 
tejun
