Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbbAUJpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:45:15 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43217 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbAUJpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:45:09 -0500
Date: Wed, 21 Jan 2015 09:44:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150121094453.GO26493@n2100.arm.linux.org.uk>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
 <20150119091705.GG21886@x1>
 <87ppaah9k5.fsf@free.fr>
 <20150120102919.GP5767@x1>
 <20150120115658.GJ26493@n2100.arm.linux.org.uk>
 <873874fuei.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873874fuei.fsf@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 08:46:29AM +0100, Robert Jarzmik wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > What I'd suggest (and always have done) is:
> >
> > 	dev_err(&pdev->dev, "couldn't request main irq%d: %d\n",
> > 		irq, ret);
> I like it, it's even more compact, I'll use it for next patch version.

BTW, this is an example why I have the policy of always ensuring that
the kernel messages print sufficient diagnostics.  Right now, I have
a problem - since I rebooted my firewall a few nights ago, I now get
on one of my machines:

  rt6_redirect: source isn't a valid nexthop for redirect target

and it spews that for a few minutes every 26 hours or so.  No further
information, and it leaves you wondering "well, what was the invalid
next hop?  What was the source?"

Pretty much the only way to try and find out is to leave a tcpdump or
wireshark running for 24 hours to try and get a dump - which is not
that easy if you don't have lots of disk space.  So, right now, I have
no way to diagnose the above.

If it printed that information, then I'd be able to see what the
addresses were, and I'd probably be able to come up with a tcpdump
filter which didn't involve logging all IPv6 traffic.

Kernel messages need to be smart.  If not, they might as well just be
"The kernel encountered a problem. Abort, Retry or Fail?"

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
