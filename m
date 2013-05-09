Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3EINnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:43:09 -0400
Received: from 2.mo3.mail-out.ovh.net ([46.105.75.36]:34685 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755139Ab3EINnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:43:07 -0400
X-Greylist: delayed 78335 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 09:43:07 EDT
Date: Thu, 9 May 2013 15:36:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-doc@vger.kernel.org,
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
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130509133645.GG3041@game.jcrosoft.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081831.48566.arnd@arndb.de>
 <alpine.LFD.2.03.1305081239260.13109@syhkavp.arg>
 <201305082035.57154.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305082035.57154.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12109334975104461572
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:35 Wed 08 May     , Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Nicolas Pitre wrote:
> > I tried to fix this up over 10 years ago.  RMK tried as well. This 
> > failed because X86 people insisted on always having COM1 as /dev/ttyS0, 
> > COM3 as /dev/ttyS2 and so on, even when some of them weren't present.
> > 
> > A common and dynamic namespace eventually succeeded for hard disks.
> > Maybe people are ready to accept it for serial ports as well now?
> 
> Unfortunately it only worked for hard disks because the old name
> space was abandoned entirely. It also caused a lot of surprises
> for people upgrading their kernels, which is something we probably
> don't want to repeat.
> 
> Now we could add a new dynamic registration facility to the tty
> layer for drivers that don't already have a name and dev_t
> associated with the driver, and then use it for all new drivers
> as well as those that intentionally want to convert.

specially that we use devtmpfs and udev

we do not care much about minor/major
> 
> With DT aliases, we already have a way to enumerate serial ports
> across device drivers, so if we are going to do something new,
> we should make sure it works with the numbers defined there.
> 
> 	Arnd
