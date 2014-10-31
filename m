Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbaJaJg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:36:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbaJaJgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:36:22 -0400
Date: Fri, 31 Oct 2014 10:36:18 +0100
From: Jan Kara <jack@suse.cz>
To: "Sergey \"Shnatsel\" Davidoff" <sergey@elementaryos.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141031093618.GB30321@quack.suse.cz>
References: <1413881397.30379.7.camel@hadess.net>
 <loom.20141021T140216-28@post.gmane.org>
 <20141027092311.GA9807@amd>
 <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABaUXi4CkosMHDuNMMhTg3Ahrts5re-rJsPxN4JNp0Wu3AbKdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27-10-14 20:02:51, Sergey "Shnatsel" Davidoff wrote:
> > If "recursive mtime" was available, would that work for you?
> 
> It would work for detecting "offline" changes. I suppose recursive
> mtime not viable for online monitoring, mostly because detecting file
> renaming would be a massive PITA (and we already have fanotify with
> exactly this problem).
  Yes, you'll get only "something has changed in a subtree" information for
each directory. You'd then have to rescan the directory to find out what
has changed. But there's no simple solution for this - either you have to
process tons of events for busy directory tree or you have to somehow
reduce the amount of information provided to userspace...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
