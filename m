Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3EDSnM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:43:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab3EDSnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:43:10 -0400
Date: Sat, 4 May 2013 19:43:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Leun <lkml20130126@newton.leun.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [REGRESSION] bisected: 3.8 -> 3.9 cannot umount after using fuse
Message-ID: <20130504184308.GE25399@ZenIV.linux.org.uk>
References: <20130504124519.032ac684@xenia.leun.net>
 <20130504155214.GD25399@ZenIV.linux.org.uk>
 <20130504200240.10a8bae0@xenia.leun.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504200240.10a8bae0@xenia.leun.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 08:02:40PM +0200, Michael Leun wrote:
> On Sat, 4 May 2013 16:52:14 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Sat, May 04, 2013 at 12:45:19PM +0200, Michael Leun wrote:
> > 
> > > After reverting 57eccb830f1cc93d4b506ba306d8dfa685e0c88f from 3.9
> > > that umount above works (not busy).
> > 
> > Sigh...  Check if the following fix works for your testcase:
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index b4f96a5..b68eef2d 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> [...]
> 
> Yup, that fixes it.

OK, committed, will go to Linus today, with Cc: stable
