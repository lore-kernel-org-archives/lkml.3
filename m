Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbbAUXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:00:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbbAUXAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:00:13 -0500
Date: Thu, 22 Jan 2015 07:00:07 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150121230007.GA10389@kroah.com>
References: <20150121171953.823177070@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121171953.823177070@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:19:53PM -0500, Steven Rostedt wrote:
> 
> There has been complaints that tracing is tied too much to debugfs,
> as there are systems that would like to perform tracing, but do
> not mount debugfs for security reasons. That is because any subsystem
> may use debugfs for debugging, and these interfaces are not always
> tested for security.
> 
> Creating a new tracefs that the tracing directory will now be attached
> to allows system admins the ability to access the tracing directory
> without the need to mount debugfs.

Yeah!

Any chance you can use kernfs as your "basis" for this filesystem
instead of having to roll all of your own functions?  I'm slowly working
on moving debugfs to it, and it should save a lot of code there, as well
as fixing some "problems" we have in debugfs file lifetimes when things
are removed from the system.

And given the number of mistakes in this submission, I'll wait for a v2
before really reading the code :)

thanks,

greg k-h
