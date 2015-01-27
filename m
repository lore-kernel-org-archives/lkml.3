Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbbA0Ein (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:38:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42640 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbA0Eil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:38:41 -0500
Date: Tue, 27 Jan 2015 04:38:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127043839.GW29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126154259.5e650d32@gandalf.local.home>
 <20150126214658.GQ29656@ZenIV.linux.org.uk>
 <20150126184314.24f2583c@gandalf.local.home>
 <20150127003742.GU29656@ZenIV.linux.org.uk>
 <20150126200218.6ecfc931@grimm.local.home>
 <20150126200350.471db2c0@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126200350.471db2c0@grimm.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 08:03:50PM -0500, Steven Rostedt wrote:
> On Mon, 26 Jan 2015 20:02:18 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> 
> > Now you see why I found just dropping the parent mutex easier.
> 
> And this is probably why kernfs does things the way it does. I can
> imagine it having the same locking issues.

The least said about kernfs locking, the better...

As for the use of trace_types_lock to serialize rmdir vs. event
addition/removal, I wonder what's wrong with actually using the
->i_mutex of /instances - you have a reference to its dentry,
after all...
