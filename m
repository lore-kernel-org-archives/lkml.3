Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaJSXTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:19:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53263 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaJSXTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:19:17 -0400
Date: Mon, 20 Oct 2014 00:19:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andrew Pinski <pinskia@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Message-ID: <20141019231908.GK7996@ZenIV.linux.org.uk>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
 <20141019210348.GA28144@drone.musicnaut.iki.fi>
 <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
 <20141019231031.GB9319@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019231031.GB9319@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 02:10:31AM +0300, Kirill A. Shutemov wrote:
> On Sun, Oct 19, 2014 at 04:05:25PM -0700, Linus Torvalds wrote:
> > On Sun, Oct 19, 2014 at 2:03 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > >
> > > Here's one example how it fails: http://marc.info/?l=gcc&m=141349914632010&w=2
> > 
> > Ok, that just looks like a gnu11 bug, then. Not being able to
> > initialize structures because some sub-structure has a volatile member
> > is just pure BS.
> > 
> > Has anybody reported this as a gcc bug? That email may be on the gcc
> > list, but I'm not seeing anybody acknowledge it as a bug..
> > 
> > I cannot imagine that anybody sane claims that this is *wanted*
> > behavior from "gnu11".
> 
> IIUC, it's nothing to do with volatile. C11 and above reads
> 
> 	(rwlock_t) { .raw_lock = { 0 }, }
> 
> as compound literal (which is not constant) rather than constant
> initalizer plus a cast.

Ah...  They hadn't even pulled it into gnu99; IIRC, they even tried to
remove it in gnu89, but Linus' complaints had stopped that attempt.
