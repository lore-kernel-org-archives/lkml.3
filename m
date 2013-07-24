Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3GXPvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:51:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38647 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752239Ab3GXPvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:51:43 -0400
Message-ID: <1374681102.18818.15.camel@joe-AO722>
Subject: Re: [PATCH 10/27] drivers/memory: don't check resource with
 devm_ioremap_resource
From: Joe Perches <joe@perches.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 08:51:42 -0700
In-Reply-To: <20130724152857.GA3016@katana>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
	 <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
	 <1374630600.10171.31.camel@joe-AO722> <20130724152857.GA3016@katana>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 17:28 +0200, Wolfram Sang wrote:
> On Tue, Jul 23, 2013 at 06:50:00PM -0700, Joe Perches wrote:
> > Hi again Wolfram
> > 
> > The next time you submit a patch series
> > please use a [PATCH 0/N] cover-letter
> > with a description of all the patches
> > and cc all the various email lists
> > on that [PATCH 0/N].
> 
> Huh? I did this and CCed all people which are CCed on the patches.
> I wrote a script extra for that.

Ah.  Well, good try.

The 0/n patch probably didn't get though vger's
maximum # of addresses spam filter.

Next time, instead of individually addressing all
the recipients on the 0/N, just cc the mailing
lists.  That greatly reduces the # of addresses
and generally gets through just fine.

If you really want to cc all the individual
MAINTAINERS, you can bcc them, but I don't do
that.  All of the MAINTAINERS should be subscribed
to one or another of the relevant mailing lists.

In my scripts I use:

[relevant bits of ~/.gitconfig]

[sendemail]
	chainreplyto = false
	thread = false
	suppresscc = self
	tocmd = ~/bin/to.sh
	cccmd = ~/bin/cc.sh

$ cat ~/bin/to.sh
#!/bin/bash

opts="--nogit --nogit-fallback --norolestats --pattern-depth=1"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    maint=$(./scripts/get_maintainer.pl --nol $opts $1)
    if [ "$maint" == "" ] ; then
	echo "linux-kernel@vger.kernel.org"
    else
	echo "$maint"
    fi
fi

$ cat ~/bin/cc.sh
#!/bin/bash

opts="--nogit --nogit-fallback --norolestats"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    ./scripts/get_maintainer.pl $opts $1

