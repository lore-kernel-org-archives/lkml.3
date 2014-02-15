Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaBOW26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 17:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbaBOW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 17:28:57 -0500
Date: Sat, 15 Feb 2014 17:28:44 -0500
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140215222844.GA18201@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Sandeen <sandeen@sandeen.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212071829.GE13997@dastard>
 <20140214002427.GN13997@dastard>
 <20140214160123.GA28125@redhat.com>
 <20140215222356.GU13997@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215222356.GU13997@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 09:23:56AM +1100, Dave Chinner wrote:
 
 > There's a pretty massive difference between the actual stack usage
 > of the local variables and the amount of stack being used by the
 > compiled code.
 > 
 > What it appears to be is that the compiler is pushing 6-10 registers
 > to the stack on every function call. So a function that only has 3
 > local variables and does very little but allocate a structure and
 > call other functions saves an 6 registers to the stack before it
 > starts:

I've got a shitload of debug options enabled, which may explain it.
Or perhaps that new STACK_PROTECTOR_STRONG stuff ?

	Dave
