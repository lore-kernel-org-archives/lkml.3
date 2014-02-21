Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbaBUXTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:19:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaBUXTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:19:23 -0500
Message-ID: <1393024759.5368.33.camel@smoke>
Subject: Re: [PATCH 2/9] ps3-vuart: don't use PREPARE_WORK
From: Geoff Levand <geoff@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
Date: Fri, 21 Feb 2014 23:19:19 +0000
In-Reply-To: <1392929071-16555-3-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
	 <1392929071-16555-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2014-02-20 at 15:44 -0500, Tejun Heo wrote:
> ps3_vuart wasn't overriding the work item with multiple work functions
> but was using NULL for INIT_WORK() and then single PREPARE_WORK() to
> set the work function.  We can simply invoke INIT_WORK() with the work
> function and remove the PREPARE_WORK() usage.
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.

I tested this on ps3 (DECR-1400) and it seems to work OK.  Please queue
with your other workqueue changes.  Thanks!

Acked-by: Geoff Levand <geoff@infradead.org>



