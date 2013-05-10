Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3EJXc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 19:32:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48204 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3EJXc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 19:32:26 -0400
Date: Sat, 11 May 2013 00:29:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130510232955.GY18614@n2100.arm.linux.org.uk>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com> <20130508161527.GA28080@kroah.com> <201305081831.48566.arnd@arndb.de> <20130508163613.GA13761@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508163613.GA13761@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 09:36:13AM -0700, Greg KH wrote:
> On Wed, May 08, 2013 at 06:31:48PM +0200, Arnd Bergmann wrote:
> > On Wednesday 08 May 2013, Greg KH wrote:
> > > > just mention there is not hardware reason to not use the generic ttySx
> > > > in place of ttyAS as we have only one IP that handle serial on this
> > > > family of SoC
> > > > 
> > > > personally I'll switch to ttySx
> > > 
> > > Great, then you can use the same major/minor range as well, so there's
> > > no more objection from me about this :)
> > 
> > Does that work these days when you have kernel with multiple built-in
> > uart drivers?
> 
> It "should", as the major/minor registration should only happen when the
> hardware is found, but I haven't tested it out, so I can't say for sure.

serial stuff has never operated like that.  More specifically, it's a
limitation with the tty stuff that the way stuff works is that a
tty driver can only drive a single bunch of contiguous minor numbers.
No interleaving is allowed.

That limitation has existed for years, and I don't see it going away.
As long as that limitation exists, you can only ever have one serial
driver driving a set of contiguous minor numbers.

There has been an attempt to "work around" this by making the 8250
driver "special" which was a complete hack to get it to work.  That
was while I maintained this stuff and I outright refused to make one
serial driver magically special.
