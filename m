Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaFFXLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:11:16 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:64664 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaFFXLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
References: <53905594d284f_71f12992fc6a@nysa.notmuch>
	<20140605133747.GB2942@dhcp22.suse.cz>
	<CAMP44s1kk8PyMd603g0C9yvHuuUZXzwwNQHpM8Abghvc_Os-SQ@mail.gmail.com>
	<20140606091620.GC26253@dhcp22.suse.cz>
	<CAMP44s2K-kZ8yLC3NPbpO9Z9ykQeySXW+cRiZ_NpLUMzDuiq9g@mail.gmail.com>
Date: Fri, 6 Jun 2014 18:11:14 -0500
Message-ID: <CAMP44s0pyjRyBM4u5-irCt0DbR96yR=hok+VZgC1KS782edN3w@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 5:33 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Fri, Jun 6, 2014 at 4:16 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
>> Mel has a nice systemtap script (attached) to watch for stalls. Maybe
>> you can give it a try?
>
> Is there any special configurations I should enable?
>
> I get this:
> semantic error: unresolved arity-1 global array name, missing global
> declaration?: identifier 'name' at /tmp/stapd6pu9A:4:2
>         source: name[t]=execname()
>                 ^
>
> Pass 2: analysis failed.  [man error::pass2]
> Number of similar error messages suppressed: 71.
> Rerun with -v to see them.
> Unexpected exit of STAP script at
> /home/felipec/Downloads/watch-dstate-new.pl line 320.

Actually I debugged the problem, and it's that the format of the
script is DOS, not UNIX. After changing the format the script works.

However, it's not returning anything. It's running, but doesn't seem
to find any stalls.

-- 
Felipe Contreras
