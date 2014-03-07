Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaCGDsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:48:11 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58390 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaCGDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:48:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+6QvSZ3FNq7X4e12chbHvNuhXXVGy2P9c=
X-DKIM: OpenDKIM Filter v2.0.1 titan 0239D53C6CF
Date: Thu, 6 Mar 2014 22:47:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 00/10] pinctrl: mvebu: remove hard-coded addresses from
 Dove pinctrl
Message-ID: <20140307034747.GP1872@titan.lakedaemon.net>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224181023.GA1010@titan.lakedaemon.net>
 <CACRpkdZ+YGTyDj6i8c198MdRtz3GY-YBmVO9LysPCcmT4EC0cg@mail.gmail.com>
 <20140226000940.GF1872@titan.lakedaemon.net>
 <CACRpkdYQa2BG_qxf5zY=7rks6O31ZF-BX0af3_u1MOgwfwxFSQ@mail.gmail.com>
 <20140226145345.GG1872@titan.lakedaemon.net>
 <CACRpkdZRJG-TzN4c3NSH9PqcQzpo6EbEn5_bM-P3sh4_vSjtaA@mail.gmail.com>
 <20140307021633.GN1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307021633.GN1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 09:16:33PM -0500, Jason Cooper wrote:
> On Fri, Mar 07, 2014 at 09:26:48AM +0800, Linus Walleij wrote:
> > On Wed, Feb 26, 2014 at 10:53 PM, Jason Cooper <jason@lakedaemon.net> wrote:
...
> > > I'm a little confused by this.  Once you merge the branch into one of
> > > yours, that merge commit is a part of the history.
> > 
> > Yes this has been discussed in the past.
> 
> Would you have a link handy?  My first thought was to create a tag, eg
> "Sent-through: subsystem <maintainer@example.com>" that I would add to
> patches as I pull them in.  After all, I know where I'm sending them.
> Or should at any rate.
> 
> > But when a developer bisects down to a certain commit and just looks
> > at it with git log there is no telling which subsystem this thing came
> > from and who actually funnelled it to Torvalds.
> 
> True.
> 
> > I do know you *can* find that out with some git magic, the problem
> > is that it is so magic that most developers don't know it and just
> > look at the signoffs.
> 
> It would be helpful if there were a complement to 'git merge-base', say
> 'git merge-tip' to point to the merge commit that joined the branch
> containing commit X.
> 
> Run in succession, it would yield committers me (I merged pinctrl-dove
> into pinctrl), you, Torvalds.

grrr.  Couldn't let it go.  If you add this alias:

  merged-by-who = log --ancestry-path --reverse --merges --format=\"%h %cD \\\"%cN <%cE>\\\"\"

to you ~/.gitconfig, then

$ git merged-by-who 2c4b229bafcf..pinctrl/for-next
08d4f0c8b131 Sat, 1 Mar 2014 07:03:36 +0000 "Jason Cooper <jason@lakedaemon.net>"
7cab36e5eee9 Sat, 1 Mar 2014 07:03:52 +0000 "Jason Cooper <jason@lakedaemon.net>"
cdfe3175eb90 Mon, 3 Mar 2014 13:39:20 +0800 "Linus Walleij <linus.walleij@linaro.org>"
a9ea2ed45a22 Mon, 3 Mar 2014 13:40:22 +0800 "Linus Walleij <linus.walleij@linaro.org>"
7bd0df13646d Wed, 5 Mar 2014 17:12:17 +0800 "Linus Walleij <linus.walleij@linaro.org>"

Once it makes it to mainline, one could use origin/master for the bottom
commit.

thx,

Jason.
