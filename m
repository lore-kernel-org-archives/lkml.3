Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaGVP1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:27:31 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:45705 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaGVP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:27:30 -0400
Date: Tue, 22 Jul 2014 11:27:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] workqueue: detach rescuer from pool until the last
Message-ID: <20140722152726.GE13851@htj.dyndns.org>
References: <20140718225159.GB5739@htj.dyndns.org>
 <1406005427-11998-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005427-11998-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:03:47PM +0800, Lai Jiangshan wrote:
> In 51697d393922 ("workqueue: use generic attach/detach routine for rescuers"),
> The rescuer detaches itself from the pool before put_pwq() so that
> the put_unbound_pool() will not destroy the rescuer-attached pool.
> 
> It is unnecessary, worker_detach_from_pool() can be used as the last
> statement to access to the pool as the same as the regular workers,
> put_unbound_pool() will wait for it to detach and then free the pool.
> 
> So we move the worker_detach_from_pool() down, make it coincide with
> the regular workers.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
