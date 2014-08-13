Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaHMT2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 15:28:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:48738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaHMT2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 15:28:01 -0400
Date: Wed, 13 Aug 2014 16:27:54 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 01/13] perf script: Fix possible memory leaks
Message-ID: <20140813192754.GF2718@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
 <1407825645-24586-2-git-send-email-namhyung@kernel.org>
 <53EB03EB.4040606@intel.com>
 <87y4usdg3v.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4usdg3v.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 13, 2014 at 04:05:24PM +0900, Namhyung Kim escreveu:
> On Wed, 13 Aug 2014 09:21:31 +0300, Adrian Hunter wrote:
> > On 08/12/2014 09:40 AM, Namhyung Kim wrote:
> >>  		input = open(file.path, O_RDONLY);	/* input_name */
> >>  		if (input < 0) {
> >>  			perror("failed to open file");
> >> -			return -1;
> >> +			err = -errno;
> >
> > Need to get errno before calling perror().
> 
> Argh, right.

I'll fix this up, no need to resubmit.

- Arnaldo
