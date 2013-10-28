Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3J1Pa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab3J1PaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:30:25 -0400
Message-ID: <1382974161.1542.18.camel@dcbw.foobar.com>
Subject: Re: [PATCH 16/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Dan Williams <dcbw@redhat.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com
Date: Mon, 28 Oct 2013 10:29:21 -0500
In-Reply-To: <201310281604.48542@pali>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382971562.1542.6.camel@dcbw.foobar.com>
	 <1382972215.17956.30.camel@jlt4.sipsolutions.net> <201310281604.48542@pali>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 16:04 +0100, Pali Rohár wrote:
> On Monday 28 October 2013 15:56:55 Johannes Berg wrote:
> > On Mon, 2013-10-28 at 09:46 -0500, Dan Williams wrote:
> > > If the device doesn't actually *have* a permanent MAC
> > > address, then it shouldn't be returning one via ethtool,
> > > and should return an error for ETHTOOL_GPERMADDR.
> > 
> > There's currently no provision for that, but I agree it would
> > be better to do so.
> > 
> > johannes
> 
> So what to do with devices which has MAC address stored in some 
> obscure place and there is userspace binary which can read it?
> 
> I think that there should be some way to tell kernel that *this* 
> is the permanent address and it should use it.
> 
> This is reason why I proposed patch which adding sysfs entry for 
> setting permanent address from userspace in wl1251 driver.

Ok, so the N900's MAC is stored in the "cal partition", which is a
region of flash exposed to the OS as /dev/mtd1.  That also stores the
regulatory domain.  Typically userspace binaries are used to pull out
this and other data (see
https://dev.openwrt.org/browser/packages/utils/calvaria/files/src/calvaria.c ) which is then used to initialize the device.

Any idea what kernel driver is used to expose the CAL partition
as /dev/mtd1?  If it's nothing special maybe a small EEPROM-style driver
could be written to read the relevant areas (and since they don't ever
change, don't need to worry about something else writing at the same
time).

Dan


