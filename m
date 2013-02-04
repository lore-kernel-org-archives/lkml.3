Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3BDV2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:28:15 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:57462 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab3BDV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:28:14 -0500
Date: Mon, 4 Feb 2013 13:28:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it
 on pool
Message-ID: <20130204212808.GC27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Fri, Feb 01, 2013 at 02:41:26AM +0800, Lai Jiangshan wrote:
> @@ -110,6 +110,7 @@ struct delayed_work {
>  	struct work_struct work;
>  	struct timer_list timer;
>  	int cpu;
> +	struct workqueue_struct *wq;

Can't we just replace delayed_work->cpu with delayed_work->cwq?  That
way, we don't enlarge delayed_work while encoding both wq and cpu in
delayed_work proper.

Thanks.

-- 
tejun
