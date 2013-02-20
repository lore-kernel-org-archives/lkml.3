Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935419Ab3BTNTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934923Ab3BTNTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:19:50 -0500
Date: Wed, 20 Feb 2013 14:19:03 +0100
From: Karel Zak <kzak@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Bryan Mason <bmason@redhat.com>
Subject: Re: [PATCH] TTY: do not reset master's packet mode
Message-ID: <20130220131903.GA8501@x2.net.home>
References: <1358288782-2946-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358288782-2946-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:26:22PM +0100, Jiri Slaby wrote:
> Now that login from util-linux is forced to drop all references to a
> TTY which it wants to hangup (to reach reference count 1) we are
> seeing issues with telnet. When login closes its last reference to the
> slave PTY, it also resets packet mode on the *master* side. And we
> have a race here.

[...]

> By this I am resurrecting an old bug, see References. We are hitting
> it regularly now, i.e. with updated util-linux, ergo login.
> 
> Here, I am changing a behavior introduced back in 2.1 times. It would
> better have a long time testing before goes upstream.

 It would be nice to found a quick way how to resolve this problem,
 because telnet+login is broken now... and for end users it seems like
 a regression.

 Maybe the requirement (patch) to close all references to TTY before
 hangup should reverted or we can make an exception in login(1) code to
 keep TTY open when login(1) is executed with -h (as used by telned).

    Karel
-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
