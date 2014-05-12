Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaELVhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:37:22 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:33955 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbaELVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:37:18 -0400
Date: Mon, 12 May 2014 17:37:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 05/10 V2] workqueue: separate iteration role from
 worker_idr
Message-ID: <20140512213714.GF18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, one more thing.

On Mon, May 12, 2014 at 02:56:17PM +0800, Lai Jiangshan wrote:
> -	struct idr		worker_idr;	/* M: worker IDs and iteration */
> +	struct idr		worker_idr;	/* M: worker IDs */
> +	struct list_head	workers;	/* M: attached workers */

Something like the following is probably more useful.

						/* M: runs through worker->node */

-- 
tejun
