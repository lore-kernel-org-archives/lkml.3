Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3EHQgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:36:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3EHQgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:36:15 -0400
Date: Wed, 8 May 2013 09:36:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
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
Message-ID: <20130508163613.GA13761@kroah.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com>
 <20130508161527.GA28080@kroah.com>
 <201305081831.48566.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305081831.48566.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:31:48PM +0200, Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Greg KH wrote:
> > > just mention there is not hardware reason to not use the generic ttySx
> > > in place of ttyAS as we have only one IP that handle serial on this
> > > family of SoC
> > > 
> > > personally I'll switch to ttySx
> > 
> > Great, then you can use the same major/minor range as well, so there's
> > no more objection from me about this :)
> 
> Does that work these days when you have kernel with multiple built-in
> uart drivers?

It "should", as the major/minor registration should only happen when the
hardware is found, but I haven't tested it out, so I can't say for sure.

> I think it would be good if all uarts were using the same name space
> and major/minor numbers, but I think the mess we currently have is
> the result of the tty_register_driver() interface reserving the
> device number range at driver load time, independent of the presence
> of devices.  I would assume that normal distro kernels always ship
> with an 8250 driver built-in to allow using that as the console,
> and if I read the code correctly, that currently prevents another
> uart driver from registering the same major/minor numbers.

We can always fix this if needed :)

thanks,

greg k-h
