Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaDUQKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:10:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDUQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:10:08 -0400
Date: Mon, 21 Apr 2014 09:09:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Rich Felker <dalias@libc.org>, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140421160927.GA19653@infradead.org>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
 <20140421140246.GB26358@brightrain.aerifal.cx>
 <535529FA.8070709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535529FA.8070709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 04:23:54PM +0200, Michael Kerrisk (man-pages) wrote:
> 
> There's at least two problems to solve here:
> 
> 1) "File private locks" is _meaningless_ as a term. Elsewhere
>    (http://thread.gmane.org/gmane.network.samba.internals/76414/focus=1685376),

It's indeed not a very good choice, but the new name is even worse.
Just call them non-broken locks? :)  Or not give them a name an just
append a 2 to the fcntls? :)

> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have names
>    that are visually very close to the traditional POSIX lock names 
>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to happen
>    when someone mistypes in code and/or misses such a misttyping
>    when reading code. That really must be fixed.

I don't think so.  They also should have a name very similar because
they have the same semantics with a major bug fixed.  In fact I can't
think of anyone who would actually want the old behavior.

