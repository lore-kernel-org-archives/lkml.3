Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3IROIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:08:52 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45054 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3IROIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:08:50 -0400
Date: Wed, 18 Sep 2013 11:08:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130918140844.GA17742@ghostprotocols.net>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com>
 <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
 <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
 <20130918101801.GO12926@twins.programming.kicks-ass.net>
 <20130918130735.GC2240@ghostprotocols.net>
 <20130918132903.GA4071@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918132903.GA4071@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 18, 2013 at 03:29:03PM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > Em Wed, Sep 18, 2013 at 12:18:01PM +0200, Peter Zijlstra escreveu:
> > > len += snprintf(str + len, size - len, ...);
> > > len += snprintf(str + len, size - len, ...);

> > And avoid snprintf like the plague, use scnprintf instead...  See
> > e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0 for details :-)

> Hm, could we do:

> 	#define snprintf scnprintf
> or:
> 	#define snprintf(x...) BUILD_BUG()
> ?

Yes, I prefer the later, with a short explanation, will do.

- Arnaldo
 
> I don't think there's any valid code, except printf wrappers (which we 
> don't have in perf), where the semantics of snprintf() would be needed.
> 
> Thanks,
> 
> 	Ingo
