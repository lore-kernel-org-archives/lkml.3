Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbaGRQUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:20:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:43795 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaGRQUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:20:08 -0400
Date: Fri, 18 Jul 2014 12:19:36 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Brent Cook <busterb@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] initial getrandom wrapper to provide getentropy
 for LibreSSL
Message-ID: <20140718161936.GA4877@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Brent Cook <busterb@gmail.com>, linux-kernel@vger.kernel.org
References: <1405666144-88053-1-git-send-email-busterb@gmail.com>
 <1158B2FC-1289-4E10-8C99-F407123B0D01@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1158B2FC-1289-4E10-8C99-F407123B0D01@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 08:09:52AM -0500, Brent Cook wrote:
> On Jul 18, 2014, at 1:49 AM, Brent Cook <busterb@gmail.com> wrote:
> 
> > From: Brent Cook <bcook@openbsd.org>
> > 
> > This is not a kernel patch, but rather an initial test of the API to see
> > how it might mesh LibreSSL's expectations for how getentropy works.
> > 
> > It is a bit more code to carefully handle the extra return values, as
> > not reading enough bytes, because there is an unhandled EINTR, might
> > lead to an unseeded CSPRNG.

Take a look at the latest patch for getrandom.  It contains a
suggested wrapper which should be sufficient for emulation of
OpenBSD's getentropy(), and a lot of discussion of when you don't need
to worry about getting the EINTR.

   http://lists.openwall.net/linux-kernel/2014/07/18/329

Again, please don't commit anything until the syscall number and
interface is finalized.  What is out here is for review, and I already
have in the git commit a suggested wrapper to provide getentropy(2).
If you don't think it's good enough, please let me know what your
concerns might be.  (And yes, I've fixed the obvious missing open
brace already.  :-)

   	      	      	  	     	      	    - Ted
