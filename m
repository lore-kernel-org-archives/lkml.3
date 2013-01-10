Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3AJWZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:25:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:26609 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3AJWZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:25:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,447,1355126400"; 
   d="scan'208";a="272439166"
Date: Thu, 10 Jan 2013 22:45:54 +0000
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        gaowanlong@cn.fujitsu.com, gregkh@linuxfoundation.org,
        frank@lichtenheld.de
Subject: Re: regression, bisected: openpty fails from 3.7 onwards without
 devpts
Message-ID: <20130110224554.1724a791@bob.linux.org.uk>
In-Reply-To: <50EEF8FD.9000004@suse.cz>
References: <20130110144626.GA26279@breakpoint.cc>
	<20130110155058.12f66e73@bob.linux.org.uk>
	<20130110162907.GB26279@breakpoint.cc>
	<50EEF8FD.9000004@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> getptsname expects EINVAL on failure to fall back to /dev/ttyp*... The
> same as unlockpt. We should definitely revert now and can teach glibc
> to accept also ENOTTY. After some years, we can try again :).

Strongly disagree for two reasons

1. We don't want to leave the other ioctls broken and non-compliant if
we can avoid it.

2. The userspace code here has quite reasonable expectations which are
that TIOCGPTN is not an unknown ioctl but is invalid to use in this
situation.

So we should just fix TIOCGPTN on a pty with no suitable name answer to
return -EINVAL (even though it would be fun to break userspace and make
Linus teach more rude words to non English speakers).

In this case I think the userspace expectations are actually perfectly
fair anyway even without considering the rather important criterion
of 'it worked last week')

Alan
