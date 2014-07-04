Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaGDLHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:07:34 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:51116 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaGDLHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:07:31 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2014 07:07:30 EDT
X-RZG-AUTH: :OGQLeEG7W+zGhULJlhi/VsQFhiZg9Tf0g6xeW+eyXiqgp15lw0W4tRg3e/1fu2Me+0q7
X-RZG-CLASS-ID: mo00
Message-ID: <53B6897F.6020802@schoebel-theuer.de>
Date: Fri, 04 Jul 2014 13:01:19 +0200
From: =?windows-1252?Q?Thomas_Sch=F6bel-Theuer?= 
	<thomas@schoebel-theuer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Selling Points for MARS Light
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi together,

since not all people have attended my presentations on MARS Light, and
since probably not all are willing to click at links such as to the
presentation slides
https://github.com/schoebel/mars/blob/master/docu/MARS_LinuxTag2014.pdf?raw=true
, I will try to explain something which goes beyond the presentations,
but nevertheless I don't want to repeat too much from the slides.

So the following is hopefully also interesting for people who attended
the presentations.

My main selling point:

To my knowledge, MARS Light is the only enterprise-grade opensource
solution constructed for mass replication of whole datacenters
(thousands to tenthousands of instances) over _long_ _distances_, aka
_geo-redundancy_.

Lets take a guided tour through important keywords given by this sentence.

1) geo-redundancy

There exist some big companies operating datacenters, typically equipped
with many thousands of servers each (in some cases it goes up to the
order of hundred-thousand servers per datacenter). Many big companies
have more than one datacenter.

CEOs are not sleeping well at night when they dream of artificial or
natural disasters such as terrorist bombing, earthquakes, fire, or
simply power blackouts due to human error or technical failures of
components which should protect against that, but don't work at the
wrong moment.

In addition, when companies are traded at the stock exchange, they are
ranked not only by the market, but also by some rating agencies.

If you (as a company) have implemented geo-redundancy as a means for
failover to a backup datacenter, your rating will improve.

If the _existence_ of your company is _depending_ on IT and it is
potentially vulnerable by such disasters, geo-redundanancy is not even a
matter of ranking, but simply a _must_.

2) long-distance

In theory, this is just a simple consequence from geo-redundancy: the
longer the distances between your datacenters, the better the protection
against large-scale disasters such as earthquakes.

There are further reasons for long distances. Probably the most
important is the cost of electricity, which is much cheaper (by
_factors_) when building your datacenters near mountains with cheap
hydro-electric power, but far away from overcrowded cities. The cost for
electricity is one of the main costs (I know some outlines of business
cases).

Further reasons are the structure of the internet: the alternative
routing / multipathing does not always work well, e.g. in case of mass
DDOS attacks. You don't want to concentrate too big masses of
datacenters nearby at the globe, and you don't want to go too far away
from the big masses of your customers / web surfers if you are a
webhosting company such as 1&1.

When you are world-wide company, distances between your datacenters are
likely to be high, naturally.

In practice, long distances raise very difficult technical problems,
which have to do with

a) Einstein's law, the speed of light (aka network latencies), and

b) network bottlenecks due to multiplexing masses of parallel data
traffic through single wide-distance fibres via routers (aka packet loss),

c) frequent short network outages, and even long-lasting network outages
_do_ occur from time to time. See the daily press.

Notice that in TCP/IP, packet loss is the _only_ means for congestion
control.

It is _impossible_ to avoid packet loss over shared long distance lines
in practice. You would need to _guarantee_ an extremely high total
bandwidth, capable of delivering every single packet from a packet
storm, or from a DDOS attack. Even if this were technically possible by
building up extremely high bandwidth capacities (which isn't in many
cases), it would be so expensive that it is essentially unaffordable.

3) replication of whole datacenters

3a) block layer

Many datacenters are hosting a wide spectrum of heterogeneous
applications. Many of them carry a _history_ (sometimes dating back over
decades), i.e. there exist many "running systems" which should "never be
touched" in sysadmin speak, or even be re-engineered just for the sake
of adding replication in order to improve your stock market ranking.
That would be expensive, and it could go wrong.

Therefore, long-distance replication is needed on block device layer.

Doing it there is _no_ _fundamental_ change of the overall architecture,
because almost every contemporary standard server has hard disks or SSDs
with a block layer interface.

Only in case of implementing _new_ applications, you could try to do
long-distance replication _always_ (consistently thoughout your whole
datacenter, even when it contains some Windows boxes) at higher levels
such as filesystem level or application level (e.g. by programming it
yourself), but I wish you good luck. There is a too wide spectrum of
applications, operating systems, storage systems, IO load behaviour, etc
for allowing general statements such as "do long-distance replication
_always_ on filesystem level". Maybe that it is _sometimes_ both
possible and affordable (and maybe sometimes even advantageous) to do
long-distance replication at filesystem or even at application level,
but not generally.

3b) synchronous vs asynchronous replication

Probably most of you already know that "synchronous" replication means
to apply a write-through strategy. A write operation is only signalled
back to the initiator as "completed" when it has been commited to all
replicas, that means transferred from the active datacenter side to the
passive one (or to _all_passive ones when having k > 2 replicas), and
after an answer indicating successful completion has been transferred
back over the network again (ping-pong game).

Some years ago, I evaluated DRBD (which works synchronously, and which
was already in productive use for _short_ distances for some years where
it worked well), but this time for long-distance replication between one
of our datacenters located in Europe and another one in USA over a 10Gig
line which is fully administrated by our WAN department, and which was
only lowly loaded at that time.

Guess the result?

Well, I did a detailed analysis using an early prototype version of my
blkreplay toolkit (see www.blkreplay.org). I used a real-life load
recorded by blktrace from shared hosting in our datacenter. Blkreplay
generates very detailed analysis graphics on latency behaviour, as well
as on many other interesting properties like workingset behaviour of the
application etc.

Ok, what do you guess?

At that time, I asked our sysadmins internally: nobody was betting that
there was a chance that it could work. All were believing that the
network latencies of ~120ms (ping) would kill the idea.

They were right with respect to the final result. It was easy to see
from the so-called "sonar diagram" graphics, even for our management,
that it does not work. I tried lots of network settings such as TCP send
buffer tuning, all available TCP congestion control algorithms including
the historic ones, etc, but nothing could help.

I strongly believe that it is not the fault of the DRBD implementation,
but the fault of synchronous replication at _concept_ level. I got oral
reports from other people inside 1&1 that similiar long-distance setups
with commercial storage boxes in synchronous mode also don't work, at
least for them.

Well, when re-looking at the old graphics with my present experience, I
should modify my former conclusions a little bit. Not the basic
latencies as such were likely killing the idea of using synchronous
replication for long distances, but the packet loss (and what's
happening after that). Details are out of scope of this discussion (you
can ask me in personal conversations).

OK, can I assume in this audience that I don't need to provide a
stronger proof that asynchronous replication is _mandatory_ for
long-distance replication?

With help from Philipp Reisner from Linbit, I also evaluated the
combination DRBD + proxy which does asynchronous replication. Since
proxy is under a commercial license, it is probably out of scope of this
discussion in this forum. For interested people: a feature comparison
between MARS Light and DRBD+proxy is on slide 4 of the LinuxTag2014
presentation.

In short: proxy uses RAM for asynchronous buffering. There is no
persistence at that point. So you can imagine why we decided not to use
it for replication of whole datacenters. Details are out of scope here.

4) enterprise grade

I am arguing on feature level here, not on maturity (where MARS Light
certainly has to catch up more, at least when compared to
long-established solutions like DRBD).

At feature level, you need at least all of the following things when
replicating whole datacenters over long distances:

a) fully automatic handover / switchover

Not only in case of disasters, but also for operational reasons such as
necessary reboots because of security fixes or kernel upgrades, you need
to switch the primary side in a controlled manner. Whenever possible,
you should avoid creating a split-brain.

Notice that the _problem space_ long-distance / asynchronous replication
bears some hidden pitfalls which are not obvious even when you are
already familiar with synchronous replication. For example, it is
impossible to eliminate split brains in general, you can only do your
best to avoid it.

b) very close-automatic resolution of split brain

That sounds easy for DRBD users, but it isn't when having huge diverging
backlogs caused by long-lasting network disruptions or other problems,
and/or when this is combined with more than 2 replicas. You may argue
that you should avoid (or even try to prohibit wherever you can) any
split brain situations in advance because you loose data upon
resolution, but such an argumentation is not practical. Shit happens in
practice.

You must be able to clean up the shit once it has happened, as
automatically as possible.

c) shared storage for the backlogs (called "transaction logs" in MARS Light)

When you have to have n resources on the same storage server (which is a
_must_ for storage consolidation in big datacenters), and n is at least
in the order of 10 (or even is planned to grow to other powers of 10 in
future), you will notice a problem which is probably not yet clear to
everyone here.

Let me try to explain it.

Probably at least the filesystem experts present in this audience will
know the 90/10 rule, sometimes also called the 80/20 rule, or other
naming variants.

It is an _observation_ from _practice_.

The rule is not only occurring in filesystems, but also in many other
places. Well-known instances are "90% of accesses go to 10% of all the
data", "10% of all files consume 90% of all storage space because they
are so big", "10% of all users create 90% of the system load", "10% of
all customers create 90% of our revenue", "90% of all complaints are
caused by 10% of all customers", and so on. The list can be extended
almost indefinitely.

Please don't argue whether 90%/10% ist "correct" or not; in some cases
the "correct" numbers are 95%/5% or even 99%/1%, while in other cases
its only 70%/30%, or whatever. It is just a practical rule of thumb
where exact numbers don't matter. In many cases the so-called "Zipf's
law" appears to be the reason for the rule, but even Zipf's law is an
observation from practice where no full scientific proof exists up to
now AFAIK.

My point is: the 90%/10% thumb rule also applies, you guess it, to what?

When you subdivide your available storage storage space into n
statically allocated ring buffers as a means for storing the backlogs
(which are _needed_ for asynchronous replication), the cited rule of
thumb says that you are wasting about one order of magnitude of storage
space when the first ring buffer is full, but all other (n - 1) ring
buffers are not yet full. The rule says that for sufficiently large n,
about 10% of all ring buffers will contain about 90% of all waste.

Imagine: translate this into € or $ for thousands or tenthousands of
servers, then you probably will get the point.

Like there is no scientific proof for Zipf's law, I cannot prove this in
strong sense. But this is just what I observe whenever I log into an
arbitrary MARS node having some long-lasting network problem, and when I
type "du -s /mars/resource-* | sort -n".

IMNSHO, this observation retrospectively justifies why an
enterprise-class asynchronous replication system needs not only a
_shared_ storage for _masses_ of backlogs, but also a _dynamic_ storage.

Some additional justification for the latter: notice that Zipf's law and
friends are not only observerable in the space dimension, but also in
the time dimension when looking at the throughput, at least when
choosing the right scale.

Consequence from this: block layer concepts, which are supposed to deal
with rather static or near-static storage spaces, are not neccesarily
the appropriate concepts when implementing huge masses of backlogs for
huge masses of resources, which in turn is needed for enterprise-class
reasons.

5) "only"

I know that there exist some opensource prototype implementations of
asynchronous long-distance replication, more or less in form of concept
studies or similar.

I don't know of any one which implements the enterprise-grade
requirements for thousands of servers / whole datacenters as pointed out
above.

--

OK, I am at the end of this posting, and I deliberately omitted the
other main selling point from the slides called "Anytime Consistency".
When interested, you can ask questions,which I will try to answer as
best as I can.

Cheers,

Thomas

