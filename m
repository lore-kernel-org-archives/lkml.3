Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3A1WIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:08:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54856 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3A1WIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:08:16 -0500
Date: Mon, 28 Jan 2013 23:08:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/12] perf, x86: Support Haswell v4 LBR format
Message-ID: <20130128220810.GV30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-6-git-send-email-andi@firstfloor.org> <CABPqkBR=vZ-S0PTZDFk03f3vXah+Ozi8KHmDGH8Q01ROO+LYFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR=vZ-S0PTZDFk03f3vXah+Ozi8KHmDGH8Q01ROO+LYFg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -               if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
> > +               if (lbr_format == LBR_FORMAT_EIP_FLAGS ||
> > +                   lbr_format == LBR_FORMAT_EIP_FLAGS2) {
> >                         mis = !!(from & LBR_FROM_FLAG_MISPRED);
> >                         pred = !mis;
> > -                       from = (u64)((((s64)from) << 1) >> 1);
> > +                       if (lbr_format == LBR_FORMAT_EIP_FLAGS)
> > +                               from = (u64)((((s64)from) << 1) >> 1);
> > +                       else if (lbr_format == LBR_FORMAT_EIP_FLAGS2) {
> > +                               intx = !!(from & LBR_FROM_FLAG_INTX);
> > +                               abort = !!(from & LBR_FROM_FLAG_ABORT);
> > +                               from = (u64)((((s64)from) << 3) >> 3);
> > +                       }
> >                 }
> >
> Wouldn't all that be more readable with a switch-case, especially given
> that lbr_format could be extended.

The current version works for me.

-Andi
