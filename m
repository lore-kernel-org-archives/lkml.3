Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaANVZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:25:08 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:37619 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaANVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:25:05 -0500
MIME-Version: 1.0
In-Reply-To: <CALwJ=MyRRjL9kXMdQgACJ6GDTMoMzMJcckuvKk1NBqJD2G07pg@mail.gmail.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
 <1389277187-18211-14-git-send-email-jlayton@redhat.com> <52CF05B5.5080700@amacapital.net>
 <20140109194930.1692fbbe@tlielax.poochiereds.net> <CALCETrXp-G2t9Lfd+tbyzWtXeBw+vLHWE4M7-297HQzyFDVU_g@mail.gmail.com>
 <20140114192713.GA22262@fieldses.org> <CALCETrWmOu-RVXNYmL--RMaiOiOMYVv5qd1+jfY0j8GZHh0rWg@mail.gmail.com>
 <CALwJ=MyRRjL9kXMdQgACJ6GDTMoMzMJcckuvKk1NBqJD2G07pg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Jan 2014 13:24:43 -0800
Message-ID: <CALCETrU98m54jd8OHZwR9av2KRenDjHCukZztVD4GCncacjX5w@mail.gmail.com>
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT locks
To: Richard Hipp <drh@sqlite.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Hipp <drh@hwaci.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 1:21 PM, Richard Hipp <drh@sqlite.org> wrote:
> I have no context here.  I'm not sure what you are discussing or what
> questions you have or what SQLite has to do with any of it.  Nevertheless, I
> have injected a few remarks inline....
>

The discussion is about a new set of fcntl locking commands that are
are respect locks acquired with the old ones but suck less.  This
seems like the right time to discuss what would make them even better.
 The immediate change is to let them be owned by the fd instead of the
process.

This might end up in POSIX and could make sqlite (and lots of other
things') lives easier.

--Andy
