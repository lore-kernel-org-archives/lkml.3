Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3BKM1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:27:07 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40908 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab3BKM1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:27:04 -0500
Date: Mon, 11 Feb 2013 13:26:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130211122654.GA5802@gmail.com>
References: <20130206214646.GA28135@gmail.com>
 <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
 <CA+55aFz9ERvaFayTy8QCtfi610Bt_r0GcOs68UNggJTHdY4oaQ@mail.gmail.com>
 <CAOJsxLFDa3sLwP2MWdXJMTfZNEopp5imy8nWNViuPnWH747ggQ@mail.gmail.com>
 <CA+55aFzEEbZqBaOKYB8H8+i904nXjNEgH=CUPtVMQU60QTTJaw@mail.gmail.com>
 <CAOJsxLFDbmNitH=N8v3jSno0SFL33s=nPc+hGRAqJfYFZS0RGw@mail.gmail.com>
 <CA+55aFy=SaVjNby=Jy_O9ZRQ_Ofc-6_+bLv=HeMMSzQQHw9vMQ@mail.gmail.com>
 <CAOJsxLFpE=HjkPcX6NsWS8636qnEhDFDJi+49xX2Ge3Xp4MeUg@mail.gmail.com>
 <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Feb 10, 2013 at 6:39 AM, Pekka Enberg <penberg@kernel.org> wrote:
> >
> > The main argument for merging into the main kernel 
> > repository has always been that (we think) it improves the 
> > kernel because significant amount of development is directly 
> > linked to kernel code (think KVM ARM port here, for 
> > example). The secondary argument has been to make it easy 
> > for kernel developers to work on both userspace and kernel 
> > in tandem (like has happened with vhost drivers). In short: 
> > it speeds up development of Linux virtualization code.
> 
> Why? You've made this statement over and over and over again, 
> and I've dismissed it over and over and over again because I 
> simply don't think it's true.
> 
> It's simply a statement with nothing to back it up. Why repeat 
> it?
> 
> THAT is my main contention. I told you why I think it's 
> actually actively untrue. You claim it helps, but what is it 
> about kvmtool that makes it so magically helpful to be inside 
> the kernel repository? What is it about this that makes it so 
> critical that you get the kernel and kvmtool with a single 
> pull, and they have to be in sync? [...]

If you are asking whether it is critical for the kernel project 
to have tools/kvm/ integrated then it isn't. The kernel will 
live just fine without it, even if that decision is a mistake.

[ In hindsight not taking the GGI code 15+ years ago was IMO a 
  (bad) mistake - yet we lived. ]

I think it's actively *useful* to the kernel project to have 
tools/kvm/ - because we already reaped some benefits and have
the commit IDs to prove it.

If you are asking why it is helpful to the tools/kvm project to 
be part of the kernel repository then there's plenty of (good) 
reasons as well. (And because it's the much smaller project, the 
benefits are much more significant to it than benefits are to 
the Linux kernel project, relatively. You'll find that to be 
true with just about any code.)

Is any of those reasons of why it's good for tools/kvm/ to be in 
the kernel repo critical? I think the *combination* is 
definitely critical. It's very much possible for each factor to 
seem 'small' in isolation but for the combination to be 
significant - denying that would be fallacy of composition.

Let me list them in case there's anything new that was not said 
before. Some of the advantages are social, some are technical:

1) 'tooling and kernel side support goes hand in hand'

I can best describe this from the tools/perf/ perspective: 
reviewing new kernel side features that has tooling impact is a 
*LOT* easier and a lot faster if it comes with readable, 
functional tooling patches.

There's no ifs and whens about it, and that alone makes 
tools/perf/ worth it to such a degree that we imposed a 
maintenance rule so that kernel side features always need to 
come with enabling tooling support.

With tools/kvm/ I saw similar effects as well - on a smaller 
scale, because due to not being upstream tools/kvm/ cannot 
realistically improve upon ABIs nearly as well as tools/perf/ 
can. Those effects will strengthen as the project grows.

For tools/kvm/ this property is optional, so unlike tools/perf/ 
you don't see it for every activity there - but there were 
several examples of that despite its optionality.

2) 'code reuse'

We utilize useful kernel code directly in user-space. It starts 
out ad-hoc and messy (and I still like Al Viro's description of 
that process back from the tools/perf/ flamewars).

We have a tools/kvm/ example of that process in action: for 
example an upcoming v3.9 feature, the user-space lockdep utility 
enabled via tools/lib/lockdep/. (Although now you might NAK 
that, I don't really understand your underlying position here.)

I am pretty confident to say that the new liblockdep and the 
'lockdep' utility (which checks pthread_mutex and pthread_rwlock 
locking in user-space - on existing binaries, using LD_PRELOAD), 
despite having been talked about for years, would simply not 
have happened without tools/kvm/ present in a kernel repo, full 
stop.

Not this year, not next year, probably not this decade. The 
reason is that the code needed several unlikely constellations 
to coincide:

 - tools/kvm attracted a capable contributor who never wrote
   kernel code before but who was interested in user-space
   coding and in virtualization code.

 - this person, over the past 2 years, learned the ropes and 
   gradually started writing kernel code as well.

 - he also learned how to interact tooling with the kernel
   proper. First the messy way, then in gradually less messy
   ways.

 - tools/kvm/ uses a user-space equivalent of kernel locking 
   primitives, such a mutex_lock()/mutex_unlock(), so his 
   experience with tools/kvm/ locking helped him kick-start 
   into looking at kernel-side locking.

 - he got to the level where he would understand lockdep.c,
   a pretty non-trivial piece of kernel code.

 - he ended up gradually validating whether lockdep could be 
   ported to user-space. He first used 'messy' integration: 
   kernel/lockdep.c hacked up badly and linked directly into 
   user-space app. Then he did 'clean' integration: some 
   modifications to kernel/lockdep.c enabled it to be 
   librarified, and then the remaining work was done in 
   user-space - here too in successive steps.

 - tools/kvm/ happened to be hosted in the same kernel repo
   that the locking tree is hosted in.

The end result is something good that I never saw happen to 
kernel code before, in the last 20 years of the Linux kernel. 
Maybe it could have happened with an outside tools/kvm repo, but 
I very strongly suspect that it would not.

In theory this could have been done in the cold, fragmented, 
isolated and desolate landscape of Linux user-space utilities, 
by copying kernel/lockdep.c and a handful of kernel headers to 
user-space, and making it work there somehow.

Just like a blue rose could in theory grow on Antarctica as 
well, given the right set of circumstances. It just so happens 
that blue roses best grow in Holland, where there's good support 
infrastructure for growing green stuff, while you'd have to look 
hard to find any green stuff at all on Antarctica.

Now is user-space lockdep something fundamental and important?

I think it's not critical in terms of technology (any of us can 
only do small code changes really), but having a new breed of 
contributors who are good at both kernel and user-space coding, 
and who do that as part of a single contribution community, is 
both refreshing and potentially important.

[ Obviously I'm seeing similar goodness in tools/perf/ as well, 
  and forcing it to split off from the kernel repo would be a 
  sad step backwards. ]

3) 'trust, distribution, testing, ease of use'

I personally tend to install a single Git tree on a test machine 
when testing the kernel: a single kernel repo. I keep that one 
updated, it's the only variable factor on that box - I don't 
change /etc/ if I can avoid it and I don't install packages and 
don't build utilities from source.

Any utility I rely on either comes with the kernel proper, or is 
already installed on the box (potentially 5 years old) - or does 
not get updated (or used much). Yes, I could clone utility Git 
repositories - but there's a barrier of usage due to several 
factors:

 - I'd have to figure out which Git repo to pull and whether to 
   trust it. I know I can generally trust the kernel repo so I 
   don't mind about doing a 'make install' there as root.

 - I'd have to make sure that the Git repo is really the latest 
   and current one of that utility. If I really only need that 
   utility marginally, why should I bother?

 - I know how to build and install it, because it follows 
   similar principles.

 - I know how to fix and enhance it, should I feel the need,
   by using the established kernel community contribution 
   infrastructure.

 - Several of my test boxes have old distros for compatibility 
   testing, where package updates and install don't work anymore 
   because all the URIs broke already, years ago. So installing 
   from source is the only option to get a recent utility.

The kernel repo gives me a single reference of 'trusted and up 
to date' stuff I need for kernel development. I only have to 
update it once and I know it's all uptodate and relevant.

If you look at any of these factors in isolation it feels small 
and borderline. In combination it's compelling to me.

Could I install a utility via distro packaging or via pulling 
another Git tree? Possibly, but see the barriers above.

4) 'We get maintenance culture imposed'

The kernel project basically offers a template and an 
enforcement mechanism. It is a very capable incubator for 
smaller projects, and I think that's a very good and useful 
thing.

I'm not aware of any similar incubators - the utility landscape 
is sadly very fragmented, with no meta project that holds it 
together, and we are hurting from that.

Could an outside project enforce the same maintenance culture? 
Only if the maintainer is very good and is doing it for the 
whole life-time of the project - and even then it would be done 
at an increased cost - right now we can just piggy back to the 
existing kernel project contribution quality rules.

In practice I've seen plenty of projects that started out good 
and then years down the road entropy ate their quality.

Too much freedom to mess up and all that - sharing 
infrastructure by related projects is good in most cases, why do 
we have to *insist* on projects to live separately and isolated?

5) 'We get to be a (minor) part of a larger, already established 
    community.'

Barriers of entry and barriers of progress are much lower within 
a single project.

Furthermore, if you are a contributor who *disagrees* with the 
concept of a cold, fragmented, inefficient and unproductive 
Linux utilities landscape that lacks a meta project framework to 
insert sanity then it's only natural to desire to be part of a 
sane project and not create yet another new, isolated project.

[ As the leader of the larger project you are obviously fully
  within your rights to reject community membership, if you feel 
  the code is harmful or just not useful enough. ]

> [...] When you then at the same time claim that you make very 
> sure that they don't have to be in sync at all. See your 
> earlier emails about how you claim to have worked very hard to 
> make sure they work across different versions.

I don't think there's any contradiction, the two concepts are 
not exclusive, it's similar to tools/perf/:

It's *very* useful to have integration, in terms of improving 
the various conditions for contribution and in terms of enabling 
code to flow efficiently both into the kernel and into tooling.

But it's not *required*, we obviously want ABI compatibility, 
want older versions to still work, etc.

So suggesting that there's a contradiction is a false dichotomy.

> So you make these unsubstantiated claims about how much easier 
> it is, and they make no sense. You never explain *why* it's so 
> magically easier. Is git so hard to use that you can't do "git 
> pull" twice? And why would you normally even *want* to do git 
> pull twice? 99% of the work in the kernel has nothing 
> what-so-ever to do with kvmtool, and hopefully the reverse is 
> equally true.

The target user base of tools/kvm/ is developers. If my personal 
experience as a tester/user of utilities in a heterogenous test 
environment matters to you:

I think the only non-kernel Git repo I ever pulled to a test box 
was the Git repo - and that was not voluntary, a 5 years old Git 
binary broke on the test box so I had to rebuild it.

I don't pull them because I had bad experience with most of 
them: they create /etc footprint that might interact with the 
validity of my ongoing testing (I try to keep installations 
pristine), quite a few of them simply don't compile on older 
systems, and they are also rather dissimilar in terms of how to 
build, install & run them. (I also find it a bit sisyphean to 
put effort into a utilities model that I don't think works very 
well.)

> And tying into the kernel just creates this myopic world of 
> only looking at the current kernel. What if somebody decides 
> that they actually want to try to boot Windows with kvmtool?

IIRC Windows support for kmvtool is work in progress - some 
patches already got applied.

Is Windows support a no-no for the Linux kernel repo?

> What if somebody tells you that they are really tired of Xen, 
> and actually want to turn kvmtool into *replacement* for Xen 
> instead? [...]

Actually, this was raised by some people - and I think some 
generalization patches were applied already but Pekka might know 
more about that ...

> [...] What if somebody wants to branch off their own work, 
> concentrating on some other issue entirely, and wants to merge 
> with upstream kvmtool but not worry about the kernel, because 
> they aren't working on the Linux kernel at all, and their work 
> is about something else?

I'm not sure I understand this question - tools/kvm/ only runs 
on a Linux kernel host, rather fundamentally, by using the (very 
Linux specific) KVM syscalls.

Hypothetically, if some other OS offered full KVM syscall 
compatibility and would start driving KVM development, then 
tools/kvm/ could accept patches related to that.

As long as the code is clean I see no problems, it would even be 
good because it might help put new features into KVM, should 
that 'other OS' improve upon the KVM syscalls. In terms of 
tools/kvm/ development we'd still think of that other OS as some 
Linux fork in essence.

So I'm not sure I fully understood this particular concern of 
yours.

Are you thinking about what happens if Linux itself dies down 
and gets replaced by some other OS, dragging down 'hosted' code 
with it? That would be very disruptive to a whole lot of other 
code as well, such as more obscure drivers, filesystems and 
kernel features that are currently only present in Linux - all 
of which would eventually find a new home with the new king OS, 
with different levels of costs of porting.

Thanks,

	Ingo
