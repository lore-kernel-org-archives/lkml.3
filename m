Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab3DZQbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:31:16 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:13376
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab3DZQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:31:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLVF7V-02-AXU-02
X-M-MSG: 
Date: Fri, 26 Apr 2013 11:31:06 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130426163106.GA25844@jshin-Toonie>
References: <20130423143423.GB17021@jshin-Toonie>
 <20130423144057.GA19644@jshin-Toonie>
 <20130423150240.GD18616@mudshark.cambridge.arm.com>
 <20130423151846.GA22052@jshin-Toonie>
 <20130424094853.GB21850@mudshark.cambridge.arm.com>
 <20130424163038.GA29816@jshin-Toonie>
 <20130425170635.GA1324@redhat.com>
 <5179652F.8080507@zytor.com>
 <20130425231911.GB31751@jshin-Toonie>
 <20130426162043.GK30858@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130426162043.GK30858@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 05:20:44PM +0100, Will Deacon wrote:
> Hi Jacob,
> 
> On Fri, Apr 26, 2013 at 12:19:11AM +0100, Jacob Shin wrote:
> > On Thu, Apr 25, 2013 at 10:17:35AM -0700, H. Peter Anvin wrote:
> > > On 04/25/2013 10:06 AM, Oleg Nesterov wrote:
> > > >>
> > > >> The downside is that in userland perf tool we need differing documentation
> > > >> on what the mask syntax means for each architecture.
> > > > 
> > > > Personally I think this is acceptable.
> > > > 
> > > > But I am new to this code, so...
> > > > 
> > > 
> > > That would seem really, really awkward.  Yes, perf has a bunch of
> > > low-level stuff, but it would seem highly undesirable to force the user
> > > to deal with something like that.
> > > 
> > > It would be good to have a user-friendly syntax that covers most of what
> > > users may want to do and perhaps a longer form that can express
> > > everything including ARM's byte selects; if the system can't honor the
> > > request it should return an error.
> > 
> > Okay,
> > 
> > If arch specific masks are a no go, then I think I'm convinced that
> > Oleg's idea of using bp_len is the right thing to do. Right now perf
> > userland tool hard codes bp_len to 4, so I need to modify it to allow
> > user to override the length if desired.
> 
> So what value ends up in the bp_len field: a length or a mask? I just want
> to make sure it's flexible enough that, if we add another user interface for
> the byte-select stuff, we don't need to butcher the attr in another way.

It is length. Just as it is today, userland API does not change at all.

> 
> > Oleg, Frederic, et al.
> > 
> > Which syntax do you prefer?
> > 
> > If we want to set bp_len to 16:
> > 
> >   $ perf stat -e mem:0x1000:rw:16
> > 
> > Or
> > 
> >   $ perf stat -e mem:0x1000:16
> > 
> > Or
> > 
> >   $ perf stat -e mem:0x1000/16
> > 
> > If no bp_len value is specified, it will still default to 4 as it did
> > before.
> 
> I certainly like the ability to change the length of an execute breakpoint,
> as that helps for halfword instructions on ARM (not sure if your first
> syntax precludes that, but just checking...).

All three are equivalent, I just need to pick one and implement/document.

-Jacob

