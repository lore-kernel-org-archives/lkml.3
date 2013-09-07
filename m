Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab3IGAAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:00:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37892 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3IGAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:00:47 -0400
Date: Sat, 7 Sep 2013 01:00:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130907000044.GX13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
 <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
 <20130906210546.GW13318@ZenIV.linux.org.uk>
 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 02:48:32PM -0700, Linus Torvalds wrote:
> On Fri, Sep 6, 2013 at 2:05 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I can take that, but I'm really not convinced that we need writer lock
> > there at all.  After all, if we really can get livelocks on that one,
> > we would be getting them on d_lookup()...
> 
> d_lookup() does a _single_ path component. That's a *big* difference.
> 
> Sure, the hash chain that d_lookup() (well, __d_lookup()) ends up
> walking is a bit more complicated than just following the dentry
> parent pointer, but that's much harder to trigger than just creating a
> really deep directory structure of single-letter nested directories,
> and then doing a "getcwd()" that walks 1024+ parents, while another
> thread is looping renaming things..
> 
> So I personally do feel a lot safer with the fallback to write locking here.
> 
> Especially since it's pretty simple, so there isn't really much downside.

Er... what will happen if you have done just what you've described and have
a process call d_lookup()?
