Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaCJRr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:47:28 -0400
Received: from imap.thunk.org ([74.207.234.97]:39460 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbaCJRr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:47:26 -0400
Date: Mon, 10 Mar 2014 13:47:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH RT] fs: jbd2: pull your plug when waiting for space
Message-ID: <20140310174718.GB6763@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mike Galbraith <bitbucket@online.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
References: <20140221123253.GA12822@linutronix.de>
 <1392990852.5451.178.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392990852.5451.178.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 02:54:12PM +0100, Mike Galbraith wrote:
> 
> ext3: dbench1 queues a buffer, blocks on journal mutex, it's plug is not
> pulled.  dbench2 mutex owner is waiting for kjournald, who is waiting for
> the buffer queued by dbench1.  Game over.

Where is in ext3/4 are we calling some function which could end up
blocking on kjournald while we have the I/O queue plugged?  That
sounds suspicious and potentially wrong.

							- Ted
