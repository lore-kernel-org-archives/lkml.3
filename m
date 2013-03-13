Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3CMR6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:58:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:32787 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab3CMR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:58:15 -0400
Date: Wed, 13 Mar 2013 10:57:29 -0700
From: Kees Cook <keescook@chromium.org>
To: ebiederm@xmission.com
Cc: Sebastian Krahmer <krahmer@suse.de>, linux-kernel@vger.kernel.org
Subject: CLONE_NEWUSER|CLONE_FS root exploit
Message-ID: <20130313175729.GH12501@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seem like we should block (at least) this combination. On 3.9, this
exploit works once uidmapping is added.

http://www.openwall.com/lists/oss-security/2013/03/13/10

-Kees

----- Forwarded message from Sebastian Krahmer <krahmer@suse.de> -----

Date: Wed, 13 Mar 2013 16:39:56 +0100
From: Sebastian Krahmer <krahmer@suse.de>
To: oss-security@lists.openwall.com
Subject: [oss-security] CLONE_NEWUSER|CLONE_FS root exploit
Envelope-To: kees@outflux.net

Hi,

Seems like CLONE_NEWUSER|CLONE_FS might be a forbidden
combination.
During evaluating the new user namespace thingie, it turned out
that its trivially exploitable to get a (real) uid 0,
as demonstrated here:

http://stealth.openwall.net/xSports/clown-newuser.c

The trick is to setup a chroot in your CLONE_NEWUSER,
but also affecting the parent, which is running
in the init_user_ns, but with the chroot shared.
Then its trivial to get a rootshell from that.

Tested on a openSUSE12.1 with a custom build 3.8.2 (x86_64).

I hope I didnt make anything wrong, mixing up the UIDs,
or disabled important checks during kernel build on my test
system. ;)

regards,
Sebastian

-- 

~ perl self.pl
~ $_='print"\$_=\47$_\47;eval"';eval
~ krahmer@suse.de - SuSE Security Team

----- End forwarded message -----

-- 
Kees Cook
Chrome OS Security
