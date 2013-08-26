Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3HZSy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:54:57 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:32966 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3HZSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:54:56 -0400
Date: Mon, 26 Aug 2013 15:54:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2 12/15] perf tools: allow non-matching sample types
Message-ID: <20130826185449.GA8765@ghostprotocols.net>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
 <1372319707-13892-13-git-send-email-adrian.hunter@intel.com>
 <51CC6AAF.4030404@gmail.com>
 <51D14CB6.206@intel.com>
 <51D1D043.5030509@gmail.com>
 <51D27CC6.1050209@intel.com>
 <CABPqkBQar4SKq_A+=ShdjJgYfxW90yuD=M=WQ2HjFwR_bKxKkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQar4SKq_A+=ShdjJgYfxW90yuD=M=WQ2HjFwR_bKxKkg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 03, 2013 at 08:44:25AM +0200, Stephane Eranian escreveu:
> On Tue, Jul 2, 2013 at 9:09 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> > It would be more compelling to provide a use-case where that "waste"
> > actually makes any difference.

> In my opinion, it's not so much of the "wasted" space than on the ease of use
> for tools. With your change, tools would have to know something about the order
> in which sample_type is laid out. And it just happens that it is not
> as trivial as
> expected. It is NOT the bit position order in sample_type. So this is more error
> prone.
 
> I prefer your IDENTIFIER solution better, yet it also implies that this flag is
> special. It provides the event ID at the first position in the sample's body.

I'm trying to process Adrian's latest batch, but then I saw this
discussion and since this compat part is the first patch and is
controversial, i.e. Stephane seems to be against it as is David Ahern, I
would like to get this compat thing to be moved to the end of the
patchset, so that we could get the parts that everybody agrees should go
in first and then further discuss the merits of forcing the
compatibility up to where we can get the PERF_SAMPLE_ID info.

Sorry Adrian, this has been thru a lot of versions :-\

I tried doing it myself, but in the end you would have to take a look to
see if I hadn't messed up something, so if you can do a  v13 with 

  [PATCH V12 01/13] perf tools: allow non-matching sample types

Moved to 13/13, I could then process the other patches and move on,

Allowing mixed sample types after this part that must be force made
compatible allows us to do things in older kernels that we can't now, so
it has merits, BTW.

Thanks,

- Arnaldo
