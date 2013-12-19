Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3LSQxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:53:15 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36739 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3LSQxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:53:13 -0500
Date: Thu, 19 Dec 2013 08:53:10 -0800
From: josh@joshtriplett.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
Message-ID: <20131219165310.GA1893@cloud>
References: <20131219163720.GB1658@cloud>
 <Pine.LNX.4.44L0.1312191142501.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312191142501.984-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:48:15AM -0500, Alan Stern wrote:
> On Thu, 19 Dec 2013 josh@joshtriplett.org wrote:
> 
> > > Of course, people have varying opinions on this issue.  As far as I 
> > > know, there is no fixed policy in the kernel about nested includes.
> > 
> > True.  I personally prefer the policy of making all headers
> > self-contained, and then only including headers that define things used
> > in the source file.  That has the advantage of not including any
> > unnecessary headers if the dependencies shrink, and not requiring
> > changes to multiple source files if the dependencies grow.
> > 
> > Any particular objection to making the headers self-contained?
> 
> I guess it depends on what you mean by "self-contained".  The only 
> reasonable definition I can think of at the moment is that you don't 
> get any errors or warnings when you compile the .h file by itself.

Or, to look at it another way, you can #include the .h file in a .c file
without any other .h file, and successfully compile the .c file and use
everything defined by the .h file.

> For that matter, how can you tell that you are including only headers 
> that define things used in the source file?  Remove each #include line, 
> one at a time, and see if you then get an error?  Do you do this after 
> each change to the source file to make sure it remains true over time?
>
> My point is that the C language design and compiler infrastructure make 
> it virtually impossible to enforce any fixed policy.

And that leaves aside all the preprocessor symbols that might change
what a header defines.  I'd argue for a best-effort policy, together
with fixing headers whenever someone notices that they're *not*
self-contained (in other words, they include a .h file to get a
definition they need, and get a compile error).

- Josh Triplett
