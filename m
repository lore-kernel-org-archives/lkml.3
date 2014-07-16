Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaGPIGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:06:14 -0400
Received: from imap.thunk.org ([74.207.234.97]:38056 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaGPIGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:06:07 -0400
Date: Wed, 16 Jul 2014 04:05:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Nick Krause <xerofoify@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
Message-ID: <20140716080553.GE1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joe Perches <joe@perches.com>, Nick Krause <xerofoify@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
	robh@kernel.org, florian.vaussard@epfl.ch,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
 <1405481937.14773.8.camel@joe-AO725>
 <CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>
 <1405484621.14773.22.camel@joe-AO725>
 <CAPDOMVi87FAukETbMbjtRqejgFN+mWfqZvP+Uw2eT===Oaz0ww@mail.gmail.com>
 <1405485592.14773.29.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405485592.14773.29.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 09:39:52PM -0700, Joe Perches wrote:
> On Wed, 2014-07-16 at 00:28 -0400, Nick Krause wrote:
> > I am cleaning up the kernel as it needs a lot of cleanup.
> 
> Needs are curious things.
> 
> Consistency is a nicety not really a need.
> 
> Bugs need fixing.  Defects need eliminating.
> Enhancements are appreciated.  Inconsistent
> code style is a minor annoyance.

Note that patches that clean up code style can in fact be actively
harmful, because it interferes with other developers who are sending
patches that fix real bugs and and add new features (because the
cleanups cause patch conflicts).

In general I will ignore patches from people who run checkpatch on
files thinking they are doing me a feature by "cleaning up" the code.
Cleanups as a part of normal code development is fine.

Note also that checkpatch in the past has been at fault for a huge
amount of code churn.  At one point, checkpatch would whine whever
lines were longer than 80 characters, causing people to send huge
numbers of pointles spatch to split printk strings across multiple
lines.  Now, checkpatch whines when it sees character strings that
span multiple lines; so other people will send equally pointless
patches to rejoin those character strings.

In general, checkpatch is good for fixing up patches so that the
maintainer won't complain over stupid nit-picky things.  But fixing
every single nit that checkpatch whines about in a while adds no
value, and in fact, can add negative value.

(Also note that there are some local coding practices where there are
very good reasons why the checkpatch whines need to be completely
ignored.  For example, you checkpatch doesn't deal well with the file
format used in include/tracing/events/*.h.  You need to know when the
right thing to do is to say, "Go home, checkpatch, you're drunk.")

						- Ted
