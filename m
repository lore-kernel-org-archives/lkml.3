Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaEAJm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:42:59 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65236 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaEAJm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:42:57 -0400
Date: Thu, 1 May 2014 11:42:52 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140501094252.GE3113@tucsk.piliscsaba.szeredi.hu>
References: <CA+55aFyqqwrtv7ifTYVK943qm2OJOF8aF1y6apMSwjG93T=ztA@mail.gmail.com>
 <20140430211206.GU18016@ZenIV.linux.org.uk>
 <20140430221238.GV18016@ZenIV.linux.org.uk>
 <CA+55aFzekh6peA627B1e3NwcL06DqErWX6whJGm4w0WDRTn1gA@mail.gmail.com>
 <CA+55aFwafZjeCEjaiAxCxQ1L9f6wBYXFsJQoSgr3681Y7=ER5w@mail.gmail.com>
 <20140430234341.GX18016@ZenIV.linux.org.uk>
 <CA+55aFyb7TPkOXmOiNQojnW-Fb-uunbqdMgiF13hE-o1t5rmcQ@mail.gmail.com>
 <20140501025105.GY18016@ZenIV.linux.org.uk>
 <CA+55aFzN=ERrtWUwAQv0ry-ZzX2k7dz3JZQT6q5zjp_ABwMg6Q@mail.gmail.com>
 <20140501031251.GZ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501031251.GZ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two points about latest version (dentry_kill-2):

- Doing anything with dentry->d_parent in case of DCACHE_DENTRY_KILLED looks
  seriously wrong.  Parent has been dealt with, at that point, by the other
  caller, no?

- "bool foo = flag & FLAG" looks suspicious.  Is this guaranteed not to
  overflow?

Thanks,
Miklos
