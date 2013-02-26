Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3BZQzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab3BZQzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:55:10 -0500
Date: Tue, 26 Feb 2013 11:54:51 -0500
From: Peter Jones <pjones@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226165451.GE32160@fenchurch.internal.datastacks.com>
References: <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
 <CAPM=9tzTXL_mystUa2=hGGzNZaYH==pMwt_PMLsWuqpRTs335g@mail.gmail.com>
 <20130226044521.GC12906@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130226044521.GC12906@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:45:21PM -0500, Theodore Ts'o wrote:
> On Tue, Feb 26, 2013 at 02:25:55PM +1000, Dave Airlie wrote:
> > 
> > Its a simple argument, MS can revoke our keys for whatever reason,
> > reducing the surface area of reasons for them to do so seems like a
> > good idea. Unless someone can read the mind of the MS guy that
> > arbitrarily decides this in 5 years time, or has some sort of signed
> > agreement, I tend towards protecting the users from having their Linux
> > not work anymore, because we were scared of a PE loader in the kernel.
> 
> If Microsoft will revoke keys for whatever reason they want, without
> any regard to the potential PR and legal consequences to Microsoft,
> there's absolutely **nothing** you can do, short of choosing to use
> more open hardware (for example, like the Chromebook Pixel).

No, no, no.  Quit saying nobody knows.  We've got a pretty good idea -
we've got a contract with them, and it says they provide the signing
service, and under circumstances where the thing being signed is found
to enable malware that circumvents Secure Boot, we'll fix it so it can't
be, and we've got a certain amount of time to do so, and processes for
working with them, and then at that time blacklists will be issued.
This is not the precise language from that contract, and I'm not going to
go into specifics here.

So in our eyes, we've got a choice between excluding unsigned modules from
the start, or waiting until there's a very quickly approaching deadline.
Obviously, for the distributions that Matthew, David, and I work on,
we've chosen protecting them from the start, and some other distributions
have chosen differently.  One might guess that those who have chosen not
to do so are expecting that we'll have come up with a solution before their
deadline day happens.

So that's where we're coming from, in terms of requiring signatures on
modules at all.  We're also in a position where some of our customers and
hardware partners see a need to load binary-only modules, and we don't want
any part in signing or distributing those, for a variety of reasons.  So
we're looking for a mechanism to allow that, and this is what we've come
up with as a technical solution.

Would I like to see the user in control?  Yes, that's why I've put time
and effort into toolchains for users doing their own signing from SB on
down.  I completely agree that any degree to which users can be
convinced to manage their security would be a good thing.  But I don't
think I can convince all that many of my users to do so, and I think a
lot of them are still going to see a need for loading modules like this.

> If you're that terrified of the completely arbitrary and capricious
> Microsoft guy having us by the short hairs, why aid and abet Microsoft
> control-freak model?

That description entirely misrepresents our concern.

-- 
        Peter
