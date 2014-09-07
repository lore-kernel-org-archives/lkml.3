Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaIGSGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:06:53 -0400
Received: from mail.us.es ([193.147.175.20]:50487 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaIGSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:06:51 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus6 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19343. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-102.4/7.5):. 
 Processed in 2.431453 secs); 07 Sep 2014 18:06:48 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Sun, 7 Sep 2014 20:07:37 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Chema Gonzalez <chema@google.com>, Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linux API <linux-api@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 net-next 2/2] net: filter: split filter.h and expose
 eBPF to user space
Message-ID: <20140907180737.GA5057@salvia>
References: <1409894238-9055-1-git-send-email-ast@plumgrid.com>
 <1409894238-9055-3-git-send-email-ast@plumgrid.com>
 <20140906141051.GA4245@salvia>
 <CAMEtUuxPynQ4wdWDgCU+9_3_GRYn8oA4f-emcF+mqiQdLsqEWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuxPynQ4wdWDgCU+9_3_GRYn8oA4f-emcF+mqiQdLsqEWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 09:04:23AM -0700, Alexei Starovoitov wrote:
> On Sat, Sep 6, 2014 at 7:10 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 04, 2014 at 10:17:18PM -0700, Alexei Starovoitov wrote:
> >> allow user space to generate eBPF programs
> >>
> >> uapi/linux/bpf.h: eBPF instruction set definition
> >>
> >> linux/filter.h: the rest
> >>
> >> This patch only moves macro definitions, but practically it freezes existing
> >> eBPF instruction set, though new instructions can still be added in the future.
> >>
> >> These eBPF definitions cannot go into uapi/linux/filter.h, since the names
> >> may conflict with existing applications.
> >>
> >> Full eBPF ISA description is in Documentation/networking/filter.txt
> >
> > I think you need to have at least one single interface using this
> > before you can expose it to userspace. So this should come in the
> > small batch that introduces the first interface of your ebpf code in
> > userspace. AFAIK, this has been the policy so far.
> 
> That's what I've been doing over the last year.
> My first eBPF patch was in Sep of 2013!
> since then I've been only tweaking and massaging it.
> Nothing fundamentally changed.
> Last few month I've been posting these series with not only
> first user, but with multiple. Many examples, test cases and so on.
> The series became big and Dave asked to split them.
> Please see the cover letter. These two patches is stage I.
> More examples and use cases in stage II, stage III, stage IV, etc

If the patches that provide the very first user interface don't get in
time to this merge window round for whatever reason, we'll have the
layout of this exposed to userspace in the next kernel version with no
clients at all, that doesn't make sense to me.

I don't think the speed up of the llvm submission is a good argument,
this sounds to me similar to the "please apply this patch that
reserves this new netlink family in include/linux/netlink.h, I promise
this new subsystem will be submitted soon though. Meanwhile this will
speed up submission of my userspace software to distributions for
packaging" argument.

I think you have to find the way to send a small batch with the very
essencial stuff that, if merged mainstream, will provide just one new
feature while leaving the repository in consistent state. Then, send
follow up patches that enhance your thing and that add new clients of
it.
