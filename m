Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3K2UJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:09:15 -0500
Received: from imap.thunk.org ([74.207.234.97]:34862 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3K2UJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:09:11 -0500
Date: Fri, 29 Nov 2013 15:09:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Price <price@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] random: simplify loop in random_read
Message-ID: <20131129200905.GD3778@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg Price <price@MIT.EDU>,
	linux-kernel@vger.kernel.org
References: <cover.1384329436.git.price@mit.edu>
 <20131113080740.GR16018@ringworld.MIT.EDU>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113080740.GR16018@ringworld.MIT.EDU>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:07:40AM -0500, Greg Price wrote:
> The loop condition never changes until just before a break, so we
> might as well write it as a constant.  Also since v2.6.33-rc7~40^2~2
> ("random: drop weird m_time/a_time manipulation") we don't do
> anything after the loop finishes, so the 'break's might as well
> return directly.  Some other simplifications.
> 
> The behavior should be identical except that I've changed a debug
> message.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Price <price@mit.edu>

Applied, although I slightly edited the commit description the the
debug message mentioned in the description was removed since the first
version of your patch series, and it wasn't updated as part of the
rebase.

						- Ted
