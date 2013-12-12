Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3LLT4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:56:09 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:16151 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3LLT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:56:05 -0500
Message-ID: <1386878159.1516.312.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Ben Hutchings <bhutchings@solarflare.com>
To: Dan Williams <dcbw@redhat.com>
CC: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Kalle Valo <kvalo@adurom.com>, Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
        <joni.lapilainen@gmail.com>, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Date: Thu, 12 Dec 2013 19:55:59 +0000
In-Reply-To: <1386802416.17188.69.camel@dcbw.foobar.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>
	 <201312101852.17030@pali>
	 <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
	 <52A8DA9A.50501@gmail.com>
	 <1386800135.1516.296.camel@bwh-desktop.uk.level5networks.com>
	 <1386802416.17188.69.camel@dcbw.foobar.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20354.005
X-TM-AS-Result: No--35.433400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 16:53 -0600, Dan Williams wrote:
> On Wed, 2013-12-11 at 22:15 +0000, Ben Hutchings wrote:
> > On Wed, 2013-12-11 at 23:35 +0200, Ivajlo Dimitrov wrote:
> > > On 11.12.2013 23:17, Ben Hutchings wrote:
> > > > I think that's an even worse idea.  This is not firmware and it already
> > > > exists in separate storage.
> > > >
> > > > I think that rx51_init_wl1251() in
> > > > arch/arm/mach-omap2/board-rx51-peripherals.c should either copy the MAC
> > > > address out of NVRAM, or if it's too early to do that, then schedule a
> > > > function to run later and only then set up wl1251 platform data.
> > > >
> > > > Ben.
> > > >
> > > 
> > > And how will that work with DT when board files will be in the history?
> > 
> > 1. Boot loader reads the MAC address from NVRAM and puts it in the DT
> > node.
> > or
> > 2. NVRAM reading is done by a tiny driver that is loaded based on the
> > platform name and updates the DT node in memory.  (But I don't know how
> > wl1251 should decide to defer probing if it's probed before that other
> > driver.)
> 
> I'm uncomfortable with it too, and yes the permanent MAC should really
> be known before the interface is even registered, but...
> 
> Imagine if the MAC address for your ethernet device was stored
> in /etc/my-mac-addr.txt, except that /etc was a read-only protected
> partition from a very small SSD.  That's essentially the N900; it's
> stored in a file in a normal ext2/ext3 (?) filesystem on a partition of
> the internal flash.

Oh, from my quick look I got the impression that this 'CAL' was stored
directly in a specific flash partition.

>   It seems like overkill to write a small driver that
> duplicates the ext3 + MTD drivers just to read the MAC.
[...]

I don't see that anything would need to be duplicated.  But reading
files from the kernel is really ugly, and deciding when to read the file
would be another problem (as you noted).

Ben

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

