Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaBZTLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:11:06 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:35844 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaBZTLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:11:02 -0500
Date: Wed, 26 Feb 2014 20:10:09 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] net: phy: add suspend_halted module param
Message-ID: <20140226191009.GC14907@lunn.ch>
References: <1393174719-20806-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140224191554.GC29288@lunn.ch>
 <530D1B7C.2090506@gmail.com>
 <20140226182117.GB14907@lunn.ch>
 <CAGVrzcYUfq84ryVET9qNJvyFCnhFdU4c0fOHbNN4eE8_w6qsAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVrzcYUfq84ryVET9qNJvyFCnhFdU4c0fOHbNN4eE8_w6qsAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As to the comment from davem about not using a kernel parameter. How
> > about turning it all around. Put a boolean parameter into DT PHY node
> > to indicate when it is safe to power down an idle phy?
> 
> Ah ah, nice try, but I do not think this belongs in DT, this is purely
> a software issue here, powering up/down the PHY itself works as
> expected.
> 
> How about we have this knob a sysfs parameter? This should be easy
> enough to tweak at runtime and debug in case thing go wrong.

With a kernel parameter i can place it into the bootargs of the chosen
node in DT. Solves the problem for everybody with a QNAP box. Same
goes for topkick and any other board which has a broken u-boot. A
sysfs parameter needs setting from user space, so it is not something
we can solve within the kernel.

   Andrew
