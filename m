Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3DYRhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:37:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab3DYRhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:37:40 -0400
Date: Thu, 25 Apr 2013 19:33:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425173356.GA2194@redhat.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com> <1366703825-19373-2-git-send-email-jacob.shin@amd.com> <20130423131844.GA24467@redhat.com> <20130423142546.GA17021@jshin-Toonie> <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com> <20130425151035.GA26760@redhat.com> <20130425165902.GA31751@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425165902.GA31751@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Jacob Shin wrote:
>
> On Thu, Apr 25, 2013 at 05:10:35PM +0200, Oleg Nesterov wrote:
> > On 04/25, Frederic Weisbecker wrote:
> > >
> > > Do we need len and mask to work at the same time? I can't think of a
> > > situation when len and mask mix up together in a useful way to define
> > > a range.
>
> Okay, we can make it:
>
> union {
>       __u64 bp_len;
>       __u64 bp_addr_mask;
>       __config2;
> };
>
> And in x86, bp_len != HW_BREAKPOINT_LEN_1,2,4,8 will be interpreted as
> bp_addr_mask.

I think this can work too. And this needs almost the same changes as
extending ->bp_len.

> > Well. Another option is to extend bp_len. Fortunately HW_BREAKPOINT_LEN_*
> > match the length, so we can simply allow any 2^n length and amd.c can
> > translate it into the mask.
>
> Okay, this is nice because we can just ride on top of what already exits,
> but ...

Yes, yes, I agree with your "but". As I said from the very beginning
I am not sure about this idea.

> addr of 0x1000 and mask of 0xf0 will count accesses to:
>
> 0x1000, 0x1010, 0x1020, .. 0x10e0, 0x10f0
>
> Maybe there is some big blob of data and user wants to see how many times
> 16 byte aligned addresses get hit. This might be not as common, but it is
> plausible no?

I'd say this is certainly uncommon ;)

But in any case we should not limit a user, so I agree.

Oleg.

