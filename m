Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbaGVPF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:05:26 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:44753 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGVPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:05:25 -0400
Date: Tue, 22 Jul 2014 11:05:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] workqueue: unfold start_worker() into create_worker()
Message-ID: <20140722150522.GD13851@htj.dyndns.org>
References: <20140718225718.GE5739@htj.dyndns.org>
 <1406005382-11958-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005382-11958-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:03:02PM +0800, Lai Jiangshan wrote:
> Simply unfold the code of start_worker() into create_worker() and
> remove the original start_worker() and create_and_start_worker().
> 
> The only trade-off is the introduced overhead that the pool->lock
> is released and regrabbed after the newly worker is started.
> The overhead is acceptible since the manager is slow path.
> 
> And because this new locking behavior, the newly created worker
> may grab the lock earlier than the manager and go to process
> work items. In this case, the recheck need_to_create_worker() may be
> true as expected and the manager goes to restart without complaint.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
