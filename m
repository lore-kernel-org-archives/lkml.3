Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbbAYUbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 15:31:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37545 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbAYUbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 15:31:19 -0500
Date: Sun, 25 Jan 2015 20:31:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150125203115.GJ29656@ZenIV.linux.org.uk>
References: <20150123155525.795129339@goodmis.org>
 <20150123162414.580817092@goodmis.org>
 <20150124030041.GB5009@kroah.com>
 <20150124063330.2c986ea2@grimm.local.home>
 <20150125132206.GA16249@kroah.com>
 <20150125143830.760c448a@gandalf.local.home>
 <20150125195932.GH29656@ZenIV.linux.org.uk>
 <20150125202729.GI29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125202729.GI29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 08:27:29PM +0000, Al Viro wrote:

> Turns out that it is better that way (and less prone to abuse).  See
> vfs.git#debugfs_automount; some massage on top of 3.19-rc5, the payoff is
> in the last commit.
> 
> For your code it's a matter of replacing struct path *path with void *unused
> in trace_automount() and just calling
> 	debugfs_create_automount("tracing", NULL, trace_automount, NULL);
> to create the sucker.  That's it - no games with ->d_op, etc.

... and the total is plus 8 lines.  Would be negative, if not for the
kerneldoc comment in there...
