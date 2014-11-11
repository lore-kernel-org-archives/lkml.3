Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaKKHhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:37:25 -0500
Received: from 1wt.eu ([62.212.114.60]:36426 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaKKHhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:37:24 -0500
Date: Tue, 11 Nov 2014 08:37:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Fix single-open policy race condition
Message-ID: <20141111073712.GD1626@1wt.eu>
References: <1415137639-569-1-git-send-email-marius.gorski@gmail.com> <20141105101910.GO6879@mwanda> <20141105115121.GA2592@firebird>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105115121.GA2592@firebird>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 12:51:22PM +0100, Mariusz Gorski wrote:
> On Wed, Nov 05, 2014 at 01:19:10PM +0300, Dan Carpenter wrote:
> > On Tue, Nov 04, 2014 at 10:47:19PM +0100, Mariusz Gorski wrote:
> > > Fix the implementation of a single-open policy for both
> > > devices (lcd and keypad) by using atomic_t instead of plain ints.
> > > 
> > 
> > This seems like it might be a real life bug that you have experienced?
> 
> No, I don't think it might really happen in real life. I found it just
> by reading the code. A similar solution is used in Chapter 6 of the LDD3
> book, so I thought it might be a good idea to fix is here.


BTW, it should be kept in mind that I first wrote this driver on 2.0 or
2.2 and it used to run on an i386. So it's extremely likely that a lot of
locking was missing by then and that until it gets discovered by code
review as Mariusz did, issues may still be present. Note that I'm currently
using this driver on production systems where this issue cannot happen
since a few scripts are allowed to send data to the LCD (which might most
always be the case by design given that nobody wants to build a system
where many scripts send unreadable crap at the same time on the display).

Thanks Mariusz for fixing this.

Willy

