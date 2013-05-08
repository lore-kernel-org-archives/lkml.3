Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3EHQn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:43:26 -0400
Received: from 9.mo4.mail-out.ovh.net ([46.105.40.176]:33014 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755276Ab3EHQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:43:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <201305081831.48566.arnd@arndb.de>
Date: Thu, 9 May 2013 00:39:44 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, Will Deacon <will.deacon@arm.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-doc@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>, Nicolas Pitre <nico@linaro.org>,
        linux-serial@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        jslaby@suse.cz, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Content-Transfer-Encoding: 7bit
Message-Id: <0940EFC0-EB16-4C13-A3DE-4A8C4F5C6F4D@jcrosoft.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com> <20130508161527.GA28080@kroah.com> <201305081831.48566.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 9232379238236072709
X-Ovh-Remote: 124.77.142.232 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9, 2013, at 12:31 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 08 May 2013, Greg KH wrote:
>>> just mention there is not hardware reason to not use the generic ttySx
>>> in place of ttyAS as we have only one IP that handle serial on this
>>> family of SoC
>>> 
>>> personally I'll switch to ttySx
>> 
>> Great, then you can use the same major/minor range as well, so there's
>> no more objection from me about this :)
> 
> Does that work these days when you have kernel with multiple built-in
> uart drivers?

not for very long time and no this family
> 
> I think it would be good if all uarts were using the same name space
> and major/minor numbers, but I think the mess we currently have is
> the result of the tty_register_driver() interface reserving the
> device number range at driver load time, independent of the presence
> of devices.  I would assume that normal distro kernels always ship
> with an 8250 driver built-in to allow using that as the console,
> and if I read the code correctly, that currently prevents another
> uart driver from registering the same major/minor numbers.

so we need to fix this
> 
> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

