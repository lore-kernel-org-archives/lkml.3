Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3H2NwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab3H2NwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:52:20 -0400
Date: Thu, 29 Aug 2013 15:52:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: perf: callchain feature on ARM - question about libunwind
 API
Message-ID: <20130829135216.GA1032@krava.brq.redhat.com>
References: <CAFrcx1n5eA4zz+nUhraE_fi_Usc=PCZTC=RCT=S285K4=jqHSg@mail.gmail.com>
 <CAFrcx1nr4-qyzC=zFRdnMavHy5p_r9Ng+zSVwNPk6snYtBm6gw@mail.gmail.com>
 <521CCFD8.90201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521CCFD8.90201@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 10:12:08AM -0600, David Ahern wrote:
> [Added Jiri who added the feature to perf]
> 
> On 8/27/13 5:58 AM, Jean Pihet wrote:
> >Hi!
> >
> >I am looking for info and help on the libunwind API.
> >
> >What I am trying to achieve is to allow the callchain feature on perf
> >for ARM (v7 to start with, then ARMv8), from the DWARF info found in
> >the .debug_frame section.
> >
> > From the source code in tools/perf I have added the call to
> >dwarf_find_debug_frame to load and parse the debug info from
> >.debug_frame. This works correctly, all IP ranges are found from the
> >debug code (test program and libraries). Then at some point I get an
> >assertion: 'perf: dwarf/Gparser.c:459: fetch_proc_info: Assertion
> >`c->pi.unwind_info' failed.' At that point c->pi is NULL. Cf. below
> >for more info.

I checked the patch and it looks ok, thought I've never touched
the .debug_frames code paths which are separated to some extend
in the libunwind code..

> >
> >It looks like I am not using the libunwind API as it should, so that
> >the perf code apparently builds a list of IP ranges to resolve but
> >cannot use it later on to gather statistics on the runtime info.
> >
> >Any idea on how to progress? I am also looking at the *_proc_info API
> >of libunwind.

keep digging ;-) also I dont have that assert exactly
at dwarf/Gparser.c:459 so maybe try latest code
git://git.sv.gnu.org/libunwind.git

sorry not to help help you much, you might try to ask
Arun Sharma <asharma@fb.com> who helped me before.

jirka
