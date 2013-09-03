Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab3ICCSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:18:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:53552 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3ICCR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:17:59 -0400
Date: Mon, 2 Sep 2013 22:17:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11
Message-ID: <20130903021753.GA15457@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFyqCJakY1+RwKXTPiGJsUcXM1W2B5gyryuq65_RKkGs0w@mail.gmail.com>
 <1378161032.32763.341.camel@haakon3.risingtidesystems.com>
 <CA+55aFwKowLGVGKrYh=ejPi1nj4ZqG+9F-kyOxHX0C+r=5=LWA@mail.gmail.com>
 <5225234A.50407@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5225234A.50407@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 04:46:18PM -0700, Guenter Roeck wrote:
> I don't think it has anything to do with linux-iscsi.org.
> Possibly Nicholas' e-mail provider is not hosted in the US, meaning e-mail
> sent through it can not be logged and examined by a certain US government agency.

Hardly.  mail.linux-iscsi.org is hosted by Rackspace, which is most
certainly in the US.  There may be spammers using some of Rackspace
subnets, which is much more likely to have something to be the issue.

I had a similar issue with thunk.org, which is hosted by Linode.  In
my case, part of the problem was that I was that I moved my host to a
different Linode datacenter (from Dallas to Atlanta), and I forgot to
update my SPF record, so e-mails with an SMTP envelope address of
tytso@thunk.org were getting a soft-fail.  (And e-mails with an SMTP
return address of tytso@mit.edu but sent from imap.thunk.org were
always getting a soft-fail, which would tend to increase the
likelihood that if the e-mail tripped other hueristics, would cause it
to be considered spam.)

Fixing my SPF record, and enabling DKIM (with a DKIM key published for
thunk.org in DNS, and making sure that I always used an SMTP envelope
return address of tytso@thunk.org, even if the RFC 822 from address
stated tytso@mit.edu) fixed the spam false positive issues for me.

(Hint: installing and configuring OpenDKIM really isn't all that hard.
I did it in less than an hour.)

> I had the same experience; Google blocks all e-mail from my private provider
> (located in Singapore). When asked by the provider, they claimed to know
> nothing about it. No, my provider doesn't forward more spam than other providers,
> and definitely less than, say, Yahoo.

One of the things that might be happening is that your private
provider may be hosting mailing lists used by companies to send
marketing "newsletters".  Unfortunately, sometimes it's a pain to
subscribe from such newsletters, and some users will just simply hit
the "it's spam" button to make such newsletters go away.  For a small
provider, it's easier for a percentage of e-mails being emitted from a
mailer to be considered spam to exceed some magic threshold, thus
increasing the "spam score" for e-mails originating from that
provider.

I'll also note that Yahoo uses DKIM (heck, it invented DKIM) and using
DKIM is useful because if someone tries to fake spam using your
domain, if your e-mails are getting signed using DKIM, and the spam is
getting sent without being DKIM signed, many of the anti-spam
filtering services defintiely do take this into account.  Some may
even automatically decrease your spam score slightly just because you
are using DKIM, just because spammers tend not to do this, and using
DKIM to sign your e-mail headers makes it easier for spam filtering
systems to hold senders accountable for spam that they send.

	  	   	      	      - Ted

P.S.  Although I work for Google, I don't know anything about the
low-level details of how Google's anti-SPAM systems work.  However,
for almost a decade, I was a member of MIT Network Operations, and was
one of the postmasters for mit.edu, back when aol.com was in its prime
(and we had a larger number of SMTP deliveries per day than AOL did).
So I know a thing or two about e-mail.... and I'd be really surprised
if anyone, particular a major mail provider such as Google, Yahoo,
Hotmail, etc, was filtering e-mail just because it came from a non-US
mail server.

The reality is that e-mail is international, and it's only the admins
of smaller mail services (perhaps desperate to filter out vast
quantities of Russian or Chinese Spam, and figuring that they weren't
expecting any valid e-mails from those countries), that would do
something as silly has filtering based on geographic source locations.
