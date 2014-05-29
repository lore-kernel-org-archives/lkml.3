Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaE2Qx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:53:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57853 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbaE2Qxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:53:55 -0400
Date: Thu, 29 May 2014 17:53:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529165351.GM18016@ZenIV.linux.org.uk>
References: <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
 <20140529053444.GI18016@ZenIV.linux.org.uk>
 <20140529105107.GB1938@lahna.fi.intel.com>
 <20140529110439.GA2006@lahna.fi.intel.com>
 <20140529133036.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
 <20140529154454.GK18016@ZenIV.linux.org.uk>
 <20140529162307.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 09:29:42AM -0700, Linus Torvalds wrote:
> On Thu, May 29, 2014 at 9:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > BTW, lock_parent() might be better off if in contended case it would not
> > bother with rename_lock and did something like this:
> > again:
> 
> Ack. I think that's much better.

Pushed to #for-linus (with dumb braino fixed - it's if (parent != dentry),
not if (parent)).  I'll wait with folding it back into the commit that
introduces lock_parent() until we get testing results...
