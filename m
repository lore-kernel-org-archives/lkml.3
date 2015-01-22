Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbbAVEXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:23:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47309 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbAVEXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:23:35 -0500
Date: Thu, 22 Jan 2015 04:23:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122042330.GU29656@ZenIV.linux.org.uk>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121230007.GA10389@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 07:00:07AM +0800, Greg Kroah-Hartman wrote:
> On Wed, Jan 21, 2015 at 12:19:53PM -0500, Steven Rostedt wrote:
> > 
> > There has been complaints that tracing is tied too much to debugfs,
> > as there are systems that would like to perform tracing, but do
> > not mount debugfs for security reasons. That is because any subsystem
> > may use debugfs for debugging, and these interfaces are not always
> > tested for security.
> > 
> > Creating a new tracefs that the tracing directory will now be attached
> > to allows system admins the ability to access the tracing directory
> > without the need to mount debugfs.
> 
> Yeah!
> 
> Any chance you can use kernfs as your "basis" for this filesystem
> instead of having to roll all of your own functions?  I'm slowly working
> on moving debugfs to it, and it should save a lot of code there, as well
> as fixing some "problems" we have in debugfs file lifetimes when things
> are removed from the system.

I would recommend against that - kernfs is overburdened by their need to
accomodate cgroup weirdness.  IMO it's not a good model for anything, other
than an anti-hard-drugs poster ("don't shoot that shit, or you might end up
hallucinating _this_").
