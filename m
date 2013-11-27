Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3K0REt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:04:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab3K0REq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:04:46 -0500
Date: Wed, 27 Nov 2013 18:05:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Add $cpu and $current probe-vars
Message-ID: <20131127170550.GB26138@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125192926.GA9737@redhat.com> <20131125192952.GB9737@redhat.com> <529405AC.6090401@hitachi.com> <20131126172313.GA14028@redhat.com> <5295ABB9.7040207@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5295ABB9.7040207@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Masami Hiramatsu wrote:
>
> (2013/11/27 2:23), Oleg Nesterov wrote:
> > On 11/26, Masami Hiramatsu wrote:
> >>
> >> (2013/11/26 4:29), Oleg Nesterov wrote:
> >>> +#define PSEUDO_REG_OFFSET	4096	/* arbitrary value > MAX_REG_OFFSET */
> >>> +
> >>> +static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offset)
> >>> +{
> >>> +	if (offset < PSEUDO_REG_OFFSET)
> >>> +		return regs_get_register(regs, offset);
> >>> +
> >>> +	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
> >>> +}
> >>
> >>
> >> Hmm, I don't like this, since fetch_reg is the most frequently
> >> used fetch method, and it actually uses the offset in different
> >> way.
> >
> > Sure, this overloads the usage of FETCH_MTD_reg/offset.
> >
> > And btw, yes, the naming is ugly (I mean pseudo_*). But why this
> > is bad? This is cheap and simple.
>
> I think it's not simple. The code looks short, but not well
> self-described. It is "hidden" in the structure, and double-meaning.

Yes, I agree. And the ugly naming doesn't make it more clear/clean.

I'll try to cleanup this somehow and resend. Perhaps I should start
with 2/2 which generalizes FETCH_MTD_reg and kills FETCH_MTD_retval.
Or at least generalizes FETCH_MTD_retval.

> >> Why don't you make another fetch function for vars?
> >
> > This is what I tried to avoid ;) I do not want to add another
> > FETCH_MTD_. To me, this looks like unnecessary complication and
> > bloat (but see below).
>
> I see, perhaps, it is a time to introduce independent fetch
> method implementation. Current one is not sophisticated
> nor generic

Yes, yes, I agree. But until then I do not want to complicate/blow
this code to implement $current.

Thanks.

Oleg.

