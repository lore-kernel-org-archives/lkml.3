Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab3DYXT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:19:26 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:45476
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758214Ab3DYXTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:19:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLU3FZ-02-DE7-02
X-M-MSG: 
Date: Thu, 25 Apr 2013 18:19:11 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Oleg Nesterov <oleg@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
Message-ID: <20130425231911.GB31751@jshin-Toonie>
References: <1366703825-19373-2-git-send-email-jacob.shin@amd.com>
 <20130423095437.GD17593@mudshark.cambridge.arm.com>
 <20130423143423.GB17021@jshin-Toonie>
 <20130423144057.GA19644@jshin-Toonie>
 <20130423150240.GD18616@mudshark.cambridge.arm.com>
 <20130423151846.GA22052@jshin-Toonie>
 <20130424094853.GB21850@mudshark.cambridge.arm.com>
 <20130424163038.GA29816@jshin-Toonie>
 <20130425170635.GA1324@redhat.com>
 <5179652F.8080507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5179652F.8080507@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:17:35AM -0700, H. Peter Anvin wrote:
> On 04/25/2013 10:06 AM, Oleg Nesterov wrote:
> >>
> >> The downside is that in userland perf tool we need differing documentation
> >> on what the mask syntax means for each architecture.
> > 
> > Personally I think this is acceptable.
> > 
> > But I am new to this code, so...
> > 
> 
> That would seem really, really awkward.  Yes, perf has a bunch of
> low-level stuff, but it would seem highly undesirable to force the user
> to deal with something like that.
> 
> It would be good to have a user-friendly syntax that covers most of what
> users may want to do and perhaps a longer form that can express
> everything including ARM's byte selects; if the system can't honor the
> request it should return an error.

Okay,

If arch specific masks are a no go, then I think I'm convinced that
Oleg's idea of using bp_len is the right thing to do. Right now perf
userland tool hard codes bp_len to 4, so I need to modify it to allow
user to override the length if desired.

Oleg, Frederic, et al.

Which syntax do you prefer?

If we want to set bp_len to 16:

  $ perf stat -e mem:0x1000:rw:16

Or

  $ perf stat -e mem:0x1000:16

Or

  $ perf stat -e mem:0x1000/16

If no bp_len value is specified, it will still default to 4 as it did
before.

