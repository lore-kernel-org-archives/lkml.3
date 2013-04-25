Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab3DYPNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458Ab3DYPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:13:45 -0400
Date: Thu, 25 Apr 2013 17:10:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425151035.GA26760@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com> <20130423131844.GA24467@redhat.com> <20130423142546.GA17021@jshin-Toonie> <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Frederic Weisbecker wrote:
>
> 2013/4/23 Jacob Shin <jacob.shin@amd.com>:
> > @@ -286,7 +286,10 @@ struct perf_event_attr {
> >                 __u64           config1; /* extension of config */
> >         };
> >         union {
> > -               __u64           bp_len;
> > +               struct {
> > +                       __u32           bp_len;
> > +                       __u32           bp_addr_mask;
> > +               };
>
> Do we need len and mask to work at the same time? I can't think of a
> situation when len and mask mix up together in a useful way to define
> a range.

And it would be nice (I think) if we could simply turn bp_len into
bp_mask. It is already the mask actually, bp_addr should be aligned.

But I do not see how we can do this, so I guess we need another field.

Well. Another option is to extend bp_len. Fortunately HW_BREAKPOINT_LEN_*
match the length, so we can simply allow any 2^n length and amd.c can
translate it into the mask.

Of course, this doesn't allow to use, say, mask=0xF0. But perhaps this
is not really useful?

I dunno. I leave this to you and Jacob ;)

Oleg.

