Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaBWWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 17:25:57 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:15390 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751978AbaBWWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 17:25:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+PCN0yjjjgywHezpXI9M7yfJhkMIbiYGM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 63FBD531862
Date: Sun, 23 Feb 2014 17:25:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/16] pinctrl: mvebu: restructure resource
 allocation
Message-ID: <20140223222545.GB14250@titan.lakedaemon.net>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140223220610.GA14250@titan.lakedaemon.net>
 <530A7252.9070200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530A7252.9070200@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 11:12:34PM +0100, Sebastian Hesselbarth wrote:
> On 02/23/2014 11:06 PM, Jason Cooper wrote:
> >On Sun, Feb 23, 2014 at 03:20:58PM +0100, Sebastian Hesselbarth wrote:
> >>This patch set restructures the common pinctrl driver part of mvebu
> >>to allow SoC specific controls to handle their own resources. Currently,
> >>the common driver maps a single resource passed by DT while the SoC
> >>specific controls cannot access that resource. To achieve the removal
> >>of knowledge of resources in the common driver, we first need to rework
> >>how SoC specific and common get/set callbacks are handled.
> >>
> >>The patch set is based on three patch sets sent earlier [1][2][3] but drops
> >>any Dove specific removal of hardcoded addresses. This allows to have
> >>a clear view on the structural changes now and Dove specific changes
> >>later on. The Dove specific patches will be re-sent on top of this one,
> >>as soon as we are all happy with the resource allcation restruturing.
> >>
> >>Also, in the meantime, pinctrl driver stubs for new Armada 375/38x have
> >>been posted [4]. Compared to v3, this patch set now also takes care of
> >>the new pinctrl stubs for Armada 375/38x. Those patches have been provided
> >>by Thomas Petazzoni and make this patches depend on them. We have no stable
> >>branch for the Armada 375/38x pinctrl patches but I guess Jason will provide
> >>one soon.
> >
> >Ok, I've applied this to mvebu/pinctrl with a dependency on
> >mvebu/pinctrl-3xx.  So this'll be in -next tonight and hopefully we'll
> >have an ideal in a few days which tree we'll send it through.
> 
> Great, thanks! I'll prepare Dove cleanup on top tomorrow. Unfortunately,
> Dove-to-mvebu progress will also depend on it. If you are unhappy
> with the triple dependency we can postpone it for v3.16 but I think it
> should be relatively easy to handle.

I'm inclined towards v3.16, we have quite a bit going on this time
around.  But let's take a look at it and see what we think.

thx,

Jason.
