Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814Ab3L2F0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 00:26:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48373 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3L2FZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 00:25:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182VitqpJ/plsHBgaV/Q6YIeNZyXlNVMbI=
X-DKIM: OpenDKIM Filter v2.0.1 titan E1E014FD892
Date: Sun, 29 Dec 2013 00:25:56 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Git puzzle
Message-ID: <20131229052556.GM19878@titan.lakedaemon.net>
References: <201312282141.40725.gheskett@wdtv.com>
 <20131229043547.GJ19878@titan.lakedaemon.net>
 <201312290011.26801.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312290011.26801.gheskett@wdtv.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene,

On Sun, Dec 29, 2013 at 12:11:26AM -0500, Gene Heskett wrote:
> On Saturday 28 December 2013, Jason Cooper wrote:
> >On Sat, Dec 28, 2013 at 09:41:40PM -0500, Gene Heskett wrote:
...
> >> working toward 3.8.3 which doesn't, and I have the disk space chowned
> >> to me, what is the exact syntax to pull a clone of 3.8.2, and then do
> >> a bisect to 3.8.3 where the microcode update for an AMD phenom doesn't
> >> work. Skipping fwd to 3.12.0 it still isn't working.
> >
> >The version tags you are referring to are from the linux-stable tree, so
> >we'll clone that one instead of Linus'.
> >
> >So, something like this:
> >
> >$ git clone \
> >git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
> >~/linux-stable
> 
> Looks like its working.
> 
> >$ cd ~/linux-stable
> >$ git checkout v3.8.3
> >$ git bisect start
> >$ git bisect bad
> >$ git bisect good v3.8.2
> >$ ...
> >
> >And now you iterate through as the manpage suggests, until it narrows it
> >down to a single commit.  Once there, report to this list with '[BUG
> >BISECTED] ...' in the subject line.
> >
> >hth,
> 
> Yes, I think I can nail it now.  One final clarification, do I use a 
> .config geared more to my machine, or am I supposed to do a "make 
> allmodconfig?"

I would use the smallest config that allows me to boot the system and
reproduce the bug.  A good starting point is /proc/config.gz from the
running system.  allmodconfig is just sticking the knife in and
twisting unnecessarily.

> I haven't done this in a while and I'm still going thru the xconfig, 
> stripping out modules for hardware I don't have, but if I just transfer the 
> old ones in, they should work but will be building about 1400 modules 
> extra.

You may want to try the opposite approach.  x86_64_defconfig, then add just
what is necessary to boot and reproduce the bug.

hth,

Jason.
