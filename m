Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaFIKCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:02:43 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33590 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaFIKCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:02:41 -0400
Date: Mon, 09 Jun 2014 05:02:36 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Michal Hocko <mhocko@suse.cz>,
        Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Message-ID: <5395863cbf23a_368f140f2f8cb@nysa.notmuch>
In-Reply-To: <20140609075358.GA7144@dhcp22.suse.cz>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
 <20140605133747.GB2942@dhcp22.suse.cz>
 <CAMP44s1kk8PyMd603g0C9yvHuuUZXzwwNQHpM8Abghvc_Os-SQ@mail.gmail.com>
 <20140606091620.GC26253@dhcp22.suse.cz>
 <CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
 <CAMP44s0pyjRyBM4u5-irCt0DbR96yR=hok+VZgC1KS782edN3w@mail.gmail.com>
 <20140609075358.GA7144@dhcp22.suse.cz>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko wrote:
> On Fri 06-06-14 18:11:14, Felipe Contreras wrote:
> > On Fri, Jun 6, 2014 at 5:33 AM, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> > > On Fri, Jun 6, 2014 at 4:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > >
> > >> Mel has a nice systemtap script (attached) to watch for stalls. Maybe
> > >> you can give it a try?
> > >
> > > Is there any special configurations I should enable?
> > >
> > > I get this:
> > > semantic error: unresolved arity-1 global array name, missing global
> > > declaration?: identifier 'name' at /tmp/stapd6pu9A:4:2
> > >         source: name[t]=execname()
> > >                 ^
> > >
> > > Pass 2: analysis failed.  [man error::pass2]
> > > Number of similar error messages suppressed: 71.
> > > Rerun with -v to see them.
> > > Unexpected exit of STAP script at
> > > /home/felipec/Downloads/watch-dstate-new.pl line 320.
> > 
> > Actually I debugged the problem, and it's that the format of the
> > script is DOS, not UNIX. After changing the format the script works.
> 
> Ups, I've downloaded it from our bugzilla so maybe it just did some
> tricks with the script.
> 
> > However, it's not returning anything. It's running, but doesn't seem
> > to find any stalls.
> 
> Intereting. It was quite good at pointing at stalls. How are you
> measuring those stalls during your testing?

I'm not measuring them, I simply grab a GUI window and move it around
while the big file is being copied, when the issue happens the window
stops moving, and the mouse, everything hangs for a time, then it
resumes, then hangs again... the interactivity is bad.

-- 
Felipe Contreras
