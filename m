Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3KZRWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab3KZRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:22:08 -0500
Date: Tue, 26 Nov 2013 18:23:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Add $cpu and $current probe-vars
Message-ID: <20131126172313.GA14028@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125192926.GA9737@redhat.com> <20131125192952.GB9737@redhat.com> <529405AC.6090401@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529405AC.6090401@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Masami Hiramatsu wrote:
>
> (2013/11/26 4:29), Oleg Nesterov wrote:
> > +#define PSEUDO_REG_OFFSET	4096	/* arbitrary value > MAX_REG_OFFSET */
> > +
> > +static unsigned long probe_get_register(struct pt_regs *regs, unsigned long offset)
> > +{
> > +	if (offset < PSEUDO_REG_OFFSET)
> > +		return regs_get_register(regs, offset);
> > +
> > +	return pseudo_reg_table[offset - PSEUDO_REG_OFFSET].fetch();
> > +}
>
>
> Hmm, I don't like this, since fetch_reg is the most frequently
> used fetch method, and it actually uses the offset in different
> way.

Sure, this overloads the usage of FETCH_MTD_reg/offset.

And btw, yes, the naming is ugly (I mean pseudo_*). But why this
is bad? This is cheap and simple.

And,

> Why don't you make another fetch function for vars?

This is what I tried to avoid ;) I do not want to add another
FETCH_MTD_. To me, this looks like unnecessary complication and
bloat (but see below).

> Perhaps, you can make fetch_retval more generic.

Please look at 2/2. It kills fetch_retval because we make
fetch_reg more generic (this patch), and this saves 300 bytes.

However. I understand that this is subjective, so please ignore.

Thanks,

Oleg.

