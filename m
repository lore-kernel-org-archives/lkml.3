Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaDWPmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbaDWPmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:42:52 -0400
Date: Wed, 23 Apr 2014 17:42:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: fix processing of pid/tid for mmap records
Message-ID: <20140423154211.GB2230@krava.brq.redhat.com>
References: <20140421160655.GA4201@quad>
 <20140422194031.GM8488@redhat.com>
 <CABPqkBTcOT+BEd1dSrp6bz22o5g+ZvBwx5e4GZvbwft6No+Shw@mail.gmail.com>
 <20140422204522.GN8488@redhat.com>
 <CABPqkBTUV65VD3D7Qcxi4=oTqBVS_WGpbFSqo561Zuex3D9ZwQ@mail.gmail.com>
 <20140423133000.GQ8488@redhat.com>
 <CABPqkBSt9N_05Lo-74Dk==_anj5Zh4+5b=26g63ozNvsWUJLVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSt9N_05Lo-74Dk==_anj5Zh4+5b=26g63ozNvsWUJLVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 05:06:21PM +0200, Stephane Eranian wrote:

SNIP

> > That is probably the behaviour we both expect.
> >
> > Jiri's patch takes all mmap events as pid maps and creates an initial map
> > for them.  All future threads that don't have mappings will trying to use
> > their pid's mapping as a fallback option.
> >
> > Because it is all pointer based now, updating the pid mappings
> > automatically update all the thread mappings too.
> >
> > I believe this approach will is the right one and makes sense.  Do you
> > think that works for you?
> >
> I just tried Jiri's 5 patches and my JIT patches, and it does work correctly.
> My Java samples are correctly symbolized. So looks like we have a solution
> that works for both of us though it seems complicated. But I can live with it.
> Thanks Jiri.

can I take this for your Tested-by?

thanks,
jirka
