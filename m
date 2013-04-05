Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162014Ab3DEQMh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 5 Apr 2013 12:12:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52311 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161948Ab3DEQMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:12:36 -0400
Date: Fri, 5 Apr 2013 17:12:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>, linux-kernel@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>, Thomas Rast <trast@inf.ethz.ch>,
        Duy Nguy???n <pclouds@gmail.com>, Jeff King <peff@peff.net>,
        Karsten Blees <karsten.blees@gmail.com>
Subject: Re: Beyond inotify recursive watches
Message-ID: <20130405161229.GC4068@ZenIV.linux.org.uk>
References: <CALkWK0nRQi+vZeVR4LVzLewhR-dUZqYANRV7yH8grp-1J7=g8Q@mail.gmail.com>
 <20130405155534.GC21852@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405155534.GC21852@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 05:55:34PM +0200, Jan Kara wrote:

> What your question reminds me is an idea of recursive modification time
> stamp on directories. That is a time stamp that gets updated whenever
> anything in the tree under the directory changes. Now this would be too
> expensive to maintain so there's also a trick implemented that you update
> the time stamp (and continue updating recursive time stamps upwards) only
> if a special flag is set on the directory. And you clear the flag at that
> moment. So until someone checks the time stamp and resets the flag no
> further updates of the recursive modification time happen.
> 
> This scheme works for arbitrary number of processes interested in recursive
> time stamps (only updates of the time stamps get more frequent). What is
> somewhat inconvenient is that this only tells you something in the
> directory or its subtree changed so you still have to scan all the
> directories on the path to modified file. So I'm not sure of how much use
> this would be to you.

Feel free to write up the details of locking you'll need for that.  It will
*not* be fun...
