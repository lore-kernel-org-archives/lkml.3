Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3LSTsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:48:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56062 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755947Ab3LSTsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:48:51 -0500
Date: Thu, 19 Dec 2013 14:48:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: josh@joshtriplett.org, Rashika Kheria <rashika.kheria@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
In-Reply-To: <52B334EF.1090202@cogentembedded.com>
Message-ID: <Pine.LNX.4.44L0.1312191440550.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Sergei Shtylyov wrote:

>     I don't really see how C language design can justify header files that 
> once included, require each .c file to #include other headers ahead of them, 
> each time such header is used. In my opinion, it's just crazy.

Okay, you've convinced me.

In this case, anyway, it makes sense to add the structure declarations
to the header file.  That's a lot less objectionable than adding a new 
include line (even though the compiler doesn't care).

By the way, if anyone cares, this discussion reminded me something
interesting.  It's sort of the opposite side of the coin, a case where
a source file would do something _different_ each time it was included.

The program itself was a fairly simple thing to calculate and print
prime numbers.  The interesting part was that this didn't happen when 
you would _run_ the program -- it happened when you _compiled_ the 
program!  Lots of preprocessor stuff to make it work.  And the only way 
to persuade the compiler to go into a loop was for the source file to 
include itself.  :-)

Alan Stern

