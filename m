Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3ECEUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:20:21 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56247 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3ECEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:20:19 -0400
Date: Thu, 2 May 2013 21:20:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>,
        Mandeep Baines <msb@chromium.org>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130503042013.GC16968@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-4-git-send-email-ccross@android.com>
 <20130502235505.GW19814@mtj.dyndns.org>
 <20130503000358.GX19814@mtj.dyndns.org>
 <CAMbhsRSFjUvkXq66pYs_nYN5At7yB4sFM+cpxLgUF_Yns54J5A@mail.gmail.com>
 <CAMbhsRTSCW3WOxTgw8btk2yWAucqNmyY-Sc+CHsHmZzf6ZsTNA@mail.gmail.com>
 <20130503040934.GA16968@mtj.dyndns.org>
 <CAMbhsRQ=zyop6ubouHAsb9CYV9Pdqo5x0fsga7wuuedj1mio4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQ=zyop6ubouHAsb9CYV9Pdqo5x0fsga7wuuedj1mio4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:17:21PM -0700, Colin Cross wrote:
> > And I *hope* the lockdep annotation is stricter than what was added
> > before.  I think it better be "no lock ever should be held at this
> > point" rather than "consider this a big lock".
> 
> The previous patch (6aa9707099c4b25700940eb3d016f16c4434360d in Linus'
> tree) already required that no locks be held, it wasn't using a lock
> annotation.

Ooh, cool.  Thanks for the pointer.  Forget about my rambling and
let's just add an unsafe version of try_to_freeze() and be done with
it.  :)

-- 
tejun
