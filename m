Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904Ab3DJPDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:03:30 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:55190
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765111Ab3DJPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:03:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(z551biz98dI9371I936eI1432I179dNzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML1OHK-01-895-02
X-M-MSG: 
Date: Wed, 10 Apr 2013 10:03:19 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
Message-ID: <20130410150319.GA10089@jshin-Toonie>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
 <1365586878.30071.33.camel@laptop>
 <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
 <1365594552.30071.63.camel@laptop>
 <1365594957.30071.66.camel@laptop>
 <20130410115647.GA8083@gmail.com>
 <CABPqkBQS3ikJWd6yXjjSKdEW3M2pNYzTSs2d56=VTx=aomWUYg@mail.gmail.com>
 <20130410122826.GD8686@gmail.com>
 <CABPqkBQ6Nzz91pzshgt1i63tjJ+3QHAuiVgKXd_RQypoeyqx6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBQ6Nzz91pzshgt1i63tjJ+3QHAuiVgKXd_RQypoeyqx6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 02:29:44PM +0200, Stephane Eranian wrote:
> On Wed, Apr 10, 2013 at 2:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> On Wed, Apr 10, 2013 at 1:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >> >
> >> >> On Wed, 2013-04-10 at 13:49 +0200, Peter Zijlstra wrote:
> >> >>
> >> >> > Hmm.. the 15h old interface bits got merged? I thought I kept telling
> >> >> > that should be done like the intel uncore stuff since the hardware
> >> >> > interface wasn't retarded anymore.
> >> >>
> >> >> Ah well, that crap seems to have slipped in in Feb when I was still a
> >> >> near vegetable and not paying much attention.
> >> >>
> >> >> /me curses a bit.
> >> >>
> >> >> I don't suppose we can deprecate it and remove this stuff?
> >> >
> >> > I think we can - if there's a functional replacement.
> >> >
> >> Does the existing code expose a type in sysfs?

It does not.

> >> If not then you cannot do this transparently, I am afraid
> >> because the syntax would be different, i.e., not cpu/...
> >
> > That could be compatibility-bridged over in tooling?
> >
> > I doubt these events are in heavy use.
> >
> I agree.

Right, I don't think they are.

> 
> >> I reviewed the code and tested it. But at the time, I thought
> >> you had agreed on the approach used.
> >
> > I did - but PeterZ has a point, so it would be nice if we could improve on that.
> >
> I think it is doable by cloning some of the functions into an amd_unc.c file.
> 

Sigh .. okay ....

