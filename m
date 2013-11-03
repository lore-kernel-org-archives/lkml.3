Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3KCTnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 14:43:19 -0500
Received: from imap.thunk.org ([74.207.234.97]:53832 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3KCTnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 14:43:17 -0500
Date: Sun, 3 Nov 2013 14:43:14 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jason Cipriani <jason.cipriani@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Correct parameter size for BLKSSZGET ioctl.
Message-ID: <20131103194314.GB7376@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jason Cipriani <jason.cipriani@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <CAF1GSti2xbHGtBx4Qq8Br9unEM_GE8GJ99fzoRm6qKaun7MHZw@mail.gmail.com>
 <20131102234451.GA10255@thunk.org>
 <CAF1GStjMyDW0tTBPtXLnDSYrQtNiL8FxNCDzM3yNYrLSRX6AhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1GStjMyDW0tTBPtXLnDSYrQtNiL8FxNCDzM3yNYrLSRX6AhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 02:07:56PM -0500, Jason Cipriani wrote:
> 
> There was a bigger question hidden behind the context there that I'm
> still wondering about: Are these ioctl interfaces specified and
> documented somewhere? From what I've seen, and from your response, the
> implication is that the kernel source *is* the specification, and not
> document exists that the kernel is expected to comply with; is this
> the case?

The kernel source is the specification.  Some of these ioctl are
documented as part of the linux man pages, for which the project home
page is here:

     https://www.kernel.org/doc/man-pages/

However, these document existing practice; if there is a discrepancy
between what is in the kernel has implemented and the Linux man pages,
it is the Linux man pages which are buggy and which will be changed.
That is man pages are descriptive, not perscriptive.

> Secondly, would it not make sense to change all ints in all public
> kernel interfaces to data types with a well-defined, machine- and
> (mostly) compiler-independent size, e.g. int32_t (or whatever)? On one
> hand, nothing seems particularly broken, per se, but on the other,
> "int" is vaguely defined and it is arguably only by chance (albeit a
> strong chance) that everything works (e.g. compilers used to build
> applications agree with compilers used to build the kernel).

Changing the parameters would result in an ABI change, which would
break programs.  So in general, it's generally not worth making these
changes.

For newer ioctls, in general we'll try to use specifically sized
types, mainly so that we don't need to do compat_ioctl handling to
support 32-bit binaries on a 64-bit kernel, but in general, it's
generally not worth changing existing ioctls.
						- Ted

