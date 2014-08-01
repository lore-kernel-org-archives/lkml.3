Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaHAUPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:15:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:57479 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaHAUPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:15:42 -0400
Date: Fri, 1 Aug 2014 17:15:38 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140801201538.GA13375@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
 <20140729050246.GC22707@bbox>
 <20140729123305.GO7831@kernel.org>
 <87ppgnhge3.fsf@sejong.aot.lge.com>
 <20140730151932.GS7831@kernel.org>
 <20140730205521.GU7831@kernel.org>
 <87ha1ygnn3.fsf@sejong.aot.lge.com>
 <20140731122621.GV7831@kernel.org>
 <87d2clgkv9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2clgkv9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 01, 2014 at 08:38:02AM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Thu, 31 Jul 2014 09:26:21 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Jul 31, 2014 at 01:25:52PM +0900, Namhyung Kim escreveu:
> >> Are you still against my approach - adding '/' at the end of the symfs
> >> string itself?  It seems that mine is simpler and shorter.

> > Yes, I am.

> > We are not just concatenating two strings, we are joining two path
> > components.

> > I think it is more clear and elegant to do it as python os.path.join()
> > does.

> Then I think you also need to care about trailing and leading '/' in the
> components so that, say, joining '/home/' and '/namhyung/' can result in
> '/home/namhyung/' not '/home///namhyung/'.

Well, "/home/namhyung/" is the same as "/home///namhyung/" for POSIX:
http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_266

So, when we can easily avoid it, no use to have a sequence of slashes,
but otherwise it is harmless.
 
> Btw, it seems like python's os.path.join() just use latter if it's an
> absolute path.
> 
>   $ python
>   Python 2.7.3 (default, Jul 24 2012, 10:05:38) 
>   [GCC 4.7.0 20120507 (Red Hat 4.7.0-5)] on linux2
>   Type "help", "copyright", "credits" or "license" for more information.
>   >>> import os.path
>   >>> os.path.join('/home/', '/namhyung/')
>   '/namhyung/'

Interesting, wonder what is the rationale for that or if this is a bug.

- Arnaldo
