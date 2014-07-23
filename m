Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbaGWPPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:15:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:52523 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbaGWPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:15:04 -0400
Date: Wed, 23 Jul 2014 11:14:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Reading large amounts from /dev/urandom broken
Message-ID: <20140723151459.GA6673@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	hannes@stressinduktion.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk81nyws__swPUoxz912wi5PJ2CBXbiLpJ-Jc4oLcX+J8vw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:52:21PM +0300, Andrey Utkin wrote:
> Dear developers, please check bugzilla ticket
> https://bugzilla.kernel.org/show_bug.cgi?id=80981 (not the initial
> issue, but starting with comment#3.
> 
> Reading from /dev/urandom gives EOF after 33554431 bytes.  I believe
> it is introduced by commit 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc,
> with the chunk
> 
> nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
> 
> which is described in commit message as "additional paranoia check to
> prevent overly large count values to be passed into urandom_read()".
> 
> I don't know why people pull such large amounts of data from urandom,
> but given today there are two bugreports regarding problems doing
> that, i consider that this is practiced.

I've inquired on the bugzilla why the reporter is abusing urandom in
this way.  The other commenter on the bug replicated the problem, but
that's not a "second bug report" in my book.

At the very least, this will probably cause me to insert a warning
printk: "insane user of /dev/urandom: [current->comm] requested %d
bytes" whenever someone tries to request more than 4k.

						- Ted
