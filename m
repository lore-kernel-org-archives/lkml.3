Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaDIEbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:31:35 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:48071 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaDIEbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:31:33 -0400
Date: Tue, 8 Apr 2014 23:31:29 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] w1: fix netlink refcnt leak on error path
Message-ID: <20140409043129.GD5096@spacedout.fries.net>
References: <1397014629-27478-1-git-send-email-David@Fries.net>
 <1397014629-27478-2-git-send-email-David@Fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397014629-27478-2-git-send-email-David@Fries.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 08 Apr 2014 23:31:30 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a bug fix, and I see from the mailing list I'm not the
only one to run into this bug, so it would be nice for this patch to
make it into this merge window.  I didn't tag this one for stable
because it doesn't apply cleanly due to previous changes that did make
it into the merge window.  Let me know if I should rewrite it for
stable and which kernel version.

The other two patches are more feature based changes.

On Tue, Apr 08, 2014 at 10:37:07PM -0500, David Fries wrote:
> If the message type is W1_MASTER_CMD or W1_SLAVE_CMD, then a reference
> is taken when searching for the slave or master device.  If there
> isn't any following data m->len (mlen is a copy) is 0 and packing up
> the message for later execution is skipped leaving nothing to
> decrement the reference counts.
> 
> Way back when, m->len was checked before the search that increments the
> reference count, but W1_LIST_MASTERS has no additional data, the check
> was moved in 9be62e0b2fadaf5ff causing this bug.
> 
> This change reorders to put the check before the reference count is
> incremented avoiding the problem.
> 
> Signed-off-by: David Fries <David@Fries.net>
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
