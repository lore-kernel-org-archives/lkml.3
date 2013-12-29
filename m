Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3L2Ef4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 23:35:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39818 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3L2Efz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 23:35:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19PVmxfqgCDqCSTqyp7kVmiNljZMsaZqyE=
X-DKIM: OpenDKIM Filter v2.0.1 titan EC4B24FD7C0
Date: Sat, 28 Dec 2013 23:35:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git puzzle
Message-ID: <20131229043547.GJ19878@titan.lakedaemon.net>
References: <201312282141.40725.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312282141.40725.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Gene,

On Sat, Dec 28, 2013 at 09:41:40PM -0500, Gene Heskett wrote:
> Hey guys, I need to setup a bisect using git but the man pages aren't 
> giving me what I need to know.  Mainly I have no clue what the URL for the 
> git repos looks like, I've been downloading and building the tarballs from 
> kernel.org all this time.

Looks like you now have your driving problem to learn git. ;-)

> Assuming I start with fresh git pull of 3.8.2 which worked,

Here's where the wheels come off the cart.  You aren't cloning a specific
revision/tag/version.  'git clone' makes a clone (hence the name) of the
entire tree's history.  Once you have a clone on your local disk, you
can then checkout _any_ version you want.  You have *all* of them.  This
is what 'git bisect' will be doing for you.

> working toward 3.8.3 which doesn't, and I have the disk space chowned
> to me, what is the exact syntax to pull a clone of 3.8.2, and then do
> a bisect to 3.8.3 where the microcode update for an AMD phenom doesn't
> work. Skipping fwd to 3.12.0 it still isn't working.

The version tags you are referring to are from the linux-stable tree, so
we'll clone that one instead of Linus'.

So, something like this:

$ git clone \
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
~/linux-stable

$ cd ~/linux-stable
$ git checkout v3.8.3
$ git bisect start
$ git bisect bad
$ git bisect good v3.8.2
$ ...

And now you iterate through as the manpage suggests, until it narrows it
down to a single commit.  Once there, report to this list with '[BUG
BISECTED] ...' in the subject line.

hth,

Jason.
