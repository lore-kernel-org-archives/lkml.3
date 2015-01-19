Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbASEzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:55:13 -0500
Received: from imap.thunk.org ([74.207.234.97]:48081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbbASEzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:55:10 -0500
Date: Sun, 18 Jan 2015 23:55:01 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Howard Chu <hyc@symas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] n_tty: Remove LINEMODE support
Message-ID: <20150119045501.GB29596@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Hurley <peter@hurleysoftware.com>, Howard Chu <hyc@symas.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <1421616632-4077-1-git-send-email-peter@hurleysoftware.com>
 <54BC2F0A.8040404@symas.com>
 <54BC3236.1030004@hurleysoftware.com>
 <54BC3730.706@symas.com>
 <54BC3C89.3070006@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BC3C89.3070006@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line mode goes back to BSD 4.x days, and it's useful over high latency
links --- i.e., the sort of thing that you get with stone age cellular
data networks (i.e., the sort of thing that we still have the US),
amateur packet radio links, etc.  So it's certianly a nice to have, if
someone is willing to support it and the maintenance burden on the
rest of the tty stack isn't too onerous.

OTOH, one could argue that with something like mosh, if you can get
that working across a particular firewall, it solves the probably much
more portably without requiring kernel hacks.  Mosh couldn't be used
on amateur packet links, since it uses encryption, which is verboten
for ham radio.  But for other high latency links, mosh does work
fairly well, without requiring EXTPROC in the kernel.

       	     	     	       	       	      - Ted
