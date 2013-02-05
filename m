Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3BETJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:09:14 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:52471 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3BETJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:09:09 -0500
Date: Tue, 5 Feb 2013 11:09:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/13] workqueue: add lock_pool_executing_work()
Message-ID: <20130205190903.GG4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-9-git-send-email-laijs@cn.fujitsu.com>
 <20130204213422.GD27963@mtj.dyndns.org>
 <5110F7D6.8080203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110F7D6.8080203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Feb 05, 2013 at 08:15:18PM +0800, Lai Jiangshan wrote:
> >So, if a work item is queued on the same CPU and it isn't being
> >executed, it will lock, look up the hash, unlock and then lock again?
> >If this is something improved by later patch, please explain so.
> >There gotta be a better way to do this, right?
> >
> 
> The caller can't call this function if the work is on queue.
> the caller should call it only when CWQ bit is not set.

Yeah, but when it's off-queue but was queued on the same CPU the last
time, we would first lock, look up the hash, find out it's not
executing, unlock and then lock the same pool again, no?

Thanks.

-- 
tejun
