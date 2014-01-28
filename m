Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaA1Rer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:34:47 -0500
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:52395 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755367AbaA1Reo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:34:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:2894:2911:2917:3138:3139:3140:3141:3142:3355:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:4425:4605:5007:6119:6691:7652:7903:7904:7974:10004:10226:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:21067,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bee47_45fc28e9d4203
X-Filterd-Recvd-Size: 4697
Message-ID: <1390930480.11756.9.camel@joe-AO722>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 28 Jan 2014 09:34:40 -0800
In-Reply-To: <CAMuHMdXciS54ZZA2TV3+JZP7szHyGOhbrdQ_1rEYUwx2YSO+Qg@mail.gmail.com>
References: <20140126122729.32113.19659.stgit@warthog.procyon.org.uk>
	 <CA+55aFz3Zi_PyQwnCS45XHO-om+XSesBby4g0WS0JcQp5i_m+Q@mail.gmail.com>
	 <20140126201928.GA8224@gmail.com> <20140126202509.GA10275@gmail.com>
	 <CAMuHMdUzGhpa0Bxa2X69-+5jFE3Y3+Kqyof5Te3Y+aUeRPzCWg@mail.gmail.com>
	 <20140128120432.GA26347@gmail.com>
	 <CAMuHMdXciS54ZZA2TV3+JZP7szHyGOhbrdQ_1rEYUwx2YSO+Qg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 13:17 +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 28, 2014 at 1:04 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> On Sun, Jan 26, 2014 at 9:25 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >> > * Ingo Molnar <mingo@kernel.org> wrote:
> >> >> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> >> > On Sun, Jan 26, 2014 at 4:27 AM, David Howells <dhowells@redhat.com> wrote:
> >> >> > > -       p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> >> >> > > +       p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> >> >> > > -       p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> >> >> > > +       p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
> >> >> >
> >> >> > So the S_IFREG isn't necessary.
> >> >> >
> >> >> > And quite frankly, I personally think S_IRUGO | S_IWUSR is _less_
> >> >> > readable than 0644. It's damn hard to parse those random letter
> >> >> > combinations, and at least I have to really think about it, in a way
> >> >> > that the octal representation does *not* make me go "I have to think
> >> >> > about that".
> >> >> >
> >> >> > So my personal preference would be to just see that simple 0644 in
> >> >> > proc_create. Hmm?

I don't have an issue with octal uses here either.

I think just as clear if not clearer than defines like

#define {whatever_}rwxrwxrwx	0777
#define {whatever_}rw_r__r__	0644
#define {whatever_}r________	0400

etc...

> >> Only a limited number of combinations is in active use, right?
> > Correct - and in fact that kind of limitation is also a security
> > feature: using patterns _outside_ of the typical, already defined
> > group of permission patterns would in itself be a 'is that really
> > justified?' red flag during review.
> 
> Then Joe (CCed :-) can write a checkpatch rule to flag all new users of the
> I_S[RWX}* flags..,

Flagging all "odd" uses of octal too?

Perhaps a checkpatch rule might look something like:
---
 scripts/checkpatch.pl | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0ea2a1e..bf278e0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -328,6 +328,12 @@ our $typeTypedefs = qr{(?x:
 	atomic_t
 )};
 
+our $permissions = qr{(?x:
+	S_I[RWX](?:USR|GRP|OTH)|
+	S_IRWX[UGO]|
+	S_I(?:RWX|ALL|R|W|X)UGO
+)};
+
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
@@ -4457,6 +4463,15 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
+
+# check for uses of permissions S_I<FOO> defines
+		if ($line =~ /\b($permissions)\b/) {
+			my $perm = $1;
+			my $msg_type = \&WARN;
+			$msg_type = \&CHK if ($file);
+			&{$msg_type}("PERMISSIONS",
+				     "Use of $perm is not preferred.\n" . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on


