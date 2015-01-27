Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbbA0Aht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:37:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbbA0Ahq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:37:46 -0500
Date: Tue, 27 Jan 2015 00:37:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150127003742.GU29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126154259.5e650d32@gandalf.local.home>
 <20150126214658.GQ29656@ZenIV.linux.org.uk>
 <20150126184314.24f2583c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126184314.24f2583c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:43:14PM -0500, Steven Rostedt wrote:

> I originally had this, but the issue isn't with i_mutex only. The
> instance_mkdir and instance_rmdir need to grab trace_types_lock. This
> is also held when calling into tracefs.
> 
> That is, we can not hold i_mutex and take trace_types_lock.
> 
> trace_types_lock needs to be held with the creation or destruction of
> events, which is what mkdir an rmdir do.

Yecchhh...

Looks like something that fell out of BKL removal - AFAICS, you are using
it to protect all kinds of things ;-/
