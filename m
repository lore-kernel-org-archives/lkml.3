Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaKSJ0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:26:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaKSJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:26:44 -0500
Date: Wed, 19 Nov 2014 10:23:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141119092323.GC2592@krava.brq.redhat.com>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjbnpv64.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 03:21:39PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Tue, 18 Nov 2014 12:00:07 +0100, Jiri Olsa wrote:
> > On Tue, Nov 18, 2014 at 11:44:16AM +0100, Jiri Olsa wrote:
> >> On Mon, Nov 17, 2014 at 06:34:57PM -0300, Arnaldo Carvalho de Melo wrote:
> >> > Em Wed, Nov 12, 2014 at 06:05:18PM -0800, Andi Kleen escreveu:
> >> > > [Reworks to address all the review feedback. Rebased to latest tree]
> >> > > [Just a repost after a rebase]
> >> > > [Even more review feedback and some bugs addressed.]
> >> > > [Only port to changes in perf/core. No other changes.]
> >> > > [Rebase to latest perf/core]
> >> > > [Another rebase. No changes]
> >> > > 
> >> > > This patchkit implements lbr-as-callgraphs in per freport,
> >> > > as an alternative way to present LBR information.
> >> > 
> >> > Ok, I have this in my perf/core branch, but I need to test it further,
> >> > as I couldn't get the output that appears on some of the changelogs.
> >> > 
> >> > If you could take a look at
> >> > 
> >> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
> >> > 
> >> > To see if I made some mistake, that would be of help,
> >> > 
> >> 
> >> I'm getting compile error for DEBUG=1
> >
> > looks like the BUILD_BUG_ON_MSG does not work correctly with -O6 we use
> 
> Nope, DEBUG=1 prevents -O6 from applied.  we have below in config/Makefile:

right.. the other way around ;))

> 
>   ifndef DEBUG
>     DEBUG := 0
>   endif
> 
>   ifeq ($(DEBUG),0)
>     CFLAGS += -O6
>   endif
> 
> 
> Looking at include/linux/bug.h, BUILD_BUG_ON is guarded under
> __OPTIMIZE__ but BUILD_BUG_ON_MSG is not.  What about changing it to
> BUILD_BUG_ON then?

sounds gut

jirka
