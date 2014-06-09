Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaFIHyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:54:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaFIHyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:54:01 -0400
Date: Mon, 9 Jun 2014 09:53:58 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
Message-ID: <20140609075358.GA7144@dhcp22.suse.cz>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
 <20140605133747.GB2942@dhcp22.suse.cz>
 <CAMP44s1kk8PyMd603g0C9yvHuuUZXzwwNQHpM8Abghvc_Os-SQ@mail.gmail.com>
 <20140606091620.GC26253@dhcp22.suse.cz>
 <CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
 <CAMP44s0pyjRyBM4u5-irCt0DbR96yR=hok+VZgC1KS782edN3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0pyjRyBM4u5-irCt0DbR96yR=hok+VZgC1KS782edN3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-06-14 18:11:14, Felipe Contreras wrote:
> On Fri, Jun 6, 2014 at 5:33 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> > On Fri, Jun 6, 2014 at 4:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> >> Mel has a nice systemtap script (attached) to watch for stalls. Maybe
> >> you can give it a try?
> >
> > Is there any special configurations I should enable?
> >
> > I get this:
> > semantic error: unresolved arity-1 global array name, missing global
> > declaration?: identifier 'name' at /tmp/stapd6pu9A:4:2
> >         source: name[t]=execname()
> >                 ^
> >
> > Pass 2: analysis failed.  [man error::pass2]
> > Number of similar error messages suppressed: 71.
> > Rerun with -v to see them.
> > Unexpected exit of STAP script at
> > /home/felipec/Downloads/watch-dstate-new.pl line 320.
> 
> Actually I debugged the problem, and it's that the format of the
> script is DOS, not UNIX. After changing the format the script works.

Ups, I've downloaded it from our bugzilla so maybe it just did some
tricks with the script.

> However, it's not returning anything. It's running, but doesn't seem
> to find any stalls.

Intereting. It was quite good at pointing at stalls. How are you
measuring those stalls during your testing?
-- 
Michal Hocko
SUSE Labs
