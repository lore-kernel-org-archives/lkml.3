Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaGaM02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:26:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:44008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaGaM01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:26:27 -0400
Date: Thu, 31 Jul 2014 09:26:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140731122621.GV7831@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
 <20140729050246.GC22707@bbox>
 <20140729123305.GO7831@kernel.org>
 <87ppgnhge3.fsf@sejong.aot.lge.com>
 <20140730151932.GS7831@kernel.org>
 <20140730205521.GU7831@kernel.org>
 <87ha1ygnn3.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha1ygnn3.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 01:25:52PM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Wed, 30 Jul 2014 17:55:21 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jul 30, 2014 at 12:19:32PM -0300, Arnaldo Carvalho de Melo escreveu:
> >> Em Wed, Jul 30, 2014 at 08:52:36AM +0900, Namhyung Kim escreveu:
> >> > I also thought about that way first but changed my mind to the current
> >> > approach because I don't want to change current behavior.
> >> 
> >> > I worried about the common case which has empty symfs.  By your patch,
> >> > it makes a pathname absolute even with an empty symfs - I can see most
> >> > filenames are already absolute paths but I'm not 100% sure it's always
> >> > the case.
> >> 
> >> Yeah, after doing some research on the tools/perf/ 'git log' I got your point,
> >> we can't add the / after symfs usages when it is "", i.e. we need something
> >> like:

> >> [acme@zoo linux]$ python
> >> >>> import os
> >> >>> symfs = ""
> >> >>> os.path.join(symfs, "dso_path")
> >> 'dso_path'
> >> >>> symfs = "/home/acme/embedded_device_dsos"
> >> >>> os.path.join(symfs, "dso_path")
> >> '/home/acme/embedded_device_dsos/dso_path'

> >> I'll try and get that in place.

> > Ok, the patch below should implement it just like above, if Minchan
> > could please retest, I did just minimal testing, will do more later.
 
> Are you still against my approach - adding '/' at the end of the symfs
> string itself?  It seems that mine is simpler and shorter.

Yes, I am.

We are not just concatenating two strings, we are joining two path
components.

I think it is more clear and elegant to do it as python os.path.join()
does.

- Arnaldo
