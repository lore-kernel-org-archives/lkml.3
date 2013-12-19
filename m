Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3LSQsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:48:18 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55936 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754155Ab3LSQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:48:16 -0500
Date: Thu, 19 Dec 2013 11:48:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: josh@joshtriplett.org
cc: Rashika Kheria <rashika.kheria@gmail.com>, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
In-Reply-To: <20131219163720.GB1658@cloud>
Message-ID: <Pine.LNX.4.44L0.1312191142501.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 josh@joshtriplett.org wrote:

> > Of course, people have varying opinions on this issue.  As far as I 
> > know, there is no fixed policy in the kernel about nested includes.
> 
> True.  I personally prefer the policy of making all headers
> self-contained, and then only including headers that define things used
> in the source file.  That has the advantage of not including any
> unnecessary headers if the dependencies shrink, and not requiring
> changes to multiple source files if the dependencies grow.
> 
> Any particular objection to making the headers self-contained?

I guess it depends on what you mean by "self-contained".  The only 
reasonable definition I can think of at the moment is that you don't 
get any errors or warnings when you compile the .h file by itself.

But what use is that in practice?  Nobody ever compiles .h files by
themselves.

For that matter, how can you tell that you are including only headers 
that define things used in the source file?  Remove each #include line, 
one at a time, and see if you then get an error?  Do you do this after 
each change to the source file to make sure it remains true over time?

My point is that the C language design and compiler infrastructure make 
it virtually impossible to enforce any fixed policy.

Alan Stern

