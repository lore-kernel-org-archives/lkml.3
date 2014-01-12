Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaALDgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 22:36:06 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:54853 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaALDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 22:36:04 -0500
Date: Sat, 11 Jan 2014 22:35:59 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu-refcount: Add a WARN() for ref going negative
Message-ID: <20140112033559.GB7874@mtj.dyndns.org>
References: <1389042806-23967-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389042806-23967-1-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:13:26PM -0800, Kent Overstreet wrote:
> AIO had a missing get, which led to an ioctx leak - after percpu_ref_kill() the
> ref was 0 so percpu_ref_put() never saw it hit 0.
> 
> This wasn't noticed at the time because it all happened completely silently,
> this adds a WARN() which would've caught the aio bug.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied to percpu/for-3.14 w/ WARN_ONCE() instead WARN().

Thanks.

-- 
tejun
