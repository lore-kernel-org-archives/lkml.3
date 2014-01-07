Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAGKvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:51:06 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37460 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaAGKvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:51:03 -0500
X-Greylist: delayed 767 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 05:51:03 EST
X-Originating-IP: 50.43.14.201
Date: Tue, 7 Jan 2014 02:50:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140107105054.GB4891@leaf>
References: <20140106204706.GA16924@leaf>
 <20140107055532.GA16581@ravnborg.org>
 <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 10:48:53AM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 7, 2014 at 6:55 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Mon, Jan 06, 2014 at 12:47:07PM -0800, Josh Triplett wrote:
> >> [CCing build-system folks and others likely to know about potential
> >> issues.]
> >>
> >> Does anyone have any objection to the use of "#pragma once" instead of
> >> the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
> >> and the latest Sparse all support either method just fine.  (I added
> >> support to Sparse myself.)  Both have equivalent performance.  "#pragma
> >> once" is simpler, and avoids the possibility of a typo in the defined
> >> guard symbol.
> > For kernel headers no concern.
> 
> Just being cautious:
> 
> Do we know the minimum gcc version that supports #pragma once?

>From checking the manuals, it goes back to at least 2.95.  Searching
suggests that versions before 3.4 have a few bugs in "#pragma once"
support, but that those bugs only apply to using #pragma once in
combination with precompiled headers, which doesn't apply to the kernel.

- Josh Triplett
