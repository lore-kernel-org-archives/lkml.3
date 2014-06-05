Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaFEQyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:54:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56470 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaFEQym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:54:42 -0400
Date: Thu, 5 Jun 2014 18:52:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Stephane Eranian <eranian@google.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605165213.GI16642@pd.tnic>
References: <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
 <CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
 <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
 <CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
 <20140605132750.GA16811@pd.tnic>
 <CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
 <20140605140316.GB16811@pd.tnic>
 <CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
 <20140605151734.GD16811@pd.tnic>
 <CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 07:39:55PM +0300, Maria Dimakopoulou wrote:
> This series aims to avoid corruption of non-corrupting events.
> Re-integration of the counts is not related to this.

What do you mean "not related"? Then you have a partial workaround. This
whole thing is trying to fix a hw bug so of course it is related.

Once you do the "full" workaround, along with the part which
reintegrates the counts and thus completely fixes the issue (I believe),
then you don't need to disable it at all because disabling it doesn't
make any sense then. See what I'm saying?

This is the whole point Matt and I are trying to make: if the *full*
workaround doesn't have any noticeable disadvantages, then you don't
need to add a disable-mechanism due to the can of worms opening if you
do.

How you get this upstream to ease the review is a whole another story
and I applaud your desire to keep things clean.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
