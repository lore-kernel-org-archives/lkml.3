Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaFLOEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:04:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60368 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbaFLOEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:04:43 -0400
Date: Thu, 12 Jun 2014 16:01:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] tools:perf: move tools/perf/util to tools/lib/perf_util
Message-ID: <20140612140119.GD4857@pd.tnic>
References: <1402561602-28807-1-git-send-email-jean.pihet@linaro.org>
 <20140612123432.GA2608@kernel.org>
 <20140612124918.GC4857@pd.tnic>
 <CAFrcx1kfUkFF9ROy2C0gcFe88aOHfv2qJBfO+uv+Z7ZW5HxQCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFrcx1kfUkFF9ROy2C0gcFe88aOHfv2qJBfO+uv+Z7ZW5HxQCw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:19:50PM +0200, Jean Pihet wrote:
> The idea is to move the re-usable code in libraries, so that other
> tools than perf can use it as well.

Of course it is - didn't I say that too?

> > And I told Jean repeatedly that this needs to be splitted slowly, in
> > smaller libraries like we've been discussing it numerous times.
> Hrrr. I see it as a first move, later the rest of the code can be
> moved the same way.
> Now it seems that moving all from util/ at once is too much. How do
> you see it happening?
> 
> Note: moving some code in the perf source is hairy enough (cf. the
> simplicity of the Makefiles ;-) and so I do not want to re-do it all
> over again too many times.

You're encountering the *exact* *same* issues I was fighting with. And I
was trying to save you that work because I did that conversion a couple
of times already! And hell yeah it is a *lot* of work! And a lot of
*wasted* work at that. Except maybe the fact that it gives you a rough
idea of what needs to be done.

So, for example, looka here:

http://lkml.kernel.org/r/20140612112534.GA24194@gmail.com

Borislav Petkov (4):
      perf tools: Move u64_swap union
      tools: Unify export.h
      tools: Consolidate types.h
      perf/events/core: Drop unused variable after cleanup

4 patches dealing with more or less one thing. No more. Once they're
accepted, you do another so many. And rinse and repeat.

And I've forwarded you the mails of how we want to split them with
Ingo's and acme's thoughts.

In any case, this is the only way I know of currently, which seems to
work right now with the amount of patches going into perf tool and with
the bandwidth of reviewers.

Additionally, if you'd like, we could sync among each other on who does
what. Maybe Robert would like to help too.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
