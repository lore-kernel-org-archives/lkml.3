Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab3BZBkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:40:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50700 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3BZBkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:40:32 -0500
Date: Mon, 25 Feb 2013 17:40:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idr: Don't WARN in idr_find
Message-ID: <20130226014027.GH2679@htj.dyndns.org>
References: <1361842632-29689-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361842632-29689-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:37:12PM -0500, Peter Hurley wrote:
> Since idr is used for syscall apis (to associate 'handles' with
> internal structures), don't WARN with invalid input.
> 
> For example, POSIX timers are identified by timer_t id. These
> ids are idr values. If userspace passes a representable timer_t id
> value (eg, id < 0) but which was not previous allocated (since the
> current idr api does not return negative idr values), then the
> syscall properly returns an error; a WARN is unnecessary and
> undesirable.

WARN_ON() on negative was intentional.  Because the previous
implmentation silently dropped the msb, we at least wanna know who has
been passing in negative indices.  Patch for the lock_timer is already
in -mm.

Thanks.

-- 
tejun
