Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3LJTV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:21:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab3LJTVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:21:54 -0500
Message-ID: <1386703339.30202.19.camel@dcbw.foobar.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Dan Williams <dcbw@redhat.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Date: Tue, 10 Dec 2013 13:22:19 -0600
In-Reply-To: <201312101852.17030@pali>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>
	 <201312101852.17030@pali>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 18:52 +0100, Pali Rohár wrote:
> On Tuesday 10 December 2013 18:49:22 Dan Williams wrote:
> > On Tue, 2013-12-10 at 18:14 +0100, Pali Rohár wrote:
> > > On Tuesday 10 December 2013 17:10:50 Pali Rohár wrote:
> > > > On Tuesday 10 December 2013 16:49:23 Kalle Valo wrote:
> > > > > Pali Rohár <pali.rohar@gmail.com> writes:
> > > > > > Driver wl1251 generating mac address randomly at
> > > > > > startup and there is no way to set permanent mac
> > > > > > address via SET_IEEE80211_PERM_ADDR. This patch
> > > > > > export sysfs file which can set permanent mac address
> > > > > > by userspace helper program. Patch is needed for
> > > > > > devices which do not store mac address in internal
> > > > > > wl1251 eeprom.
> > > > > > 
> > > > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > > 
> > > > > We have ioctl() command for setting the mac address.
> > > > 
> > > > Really? Is there ioctl for setting permanent mac address?
> > > > Can you show me it?
> > > 
> > > Now I looked at it again and I did not found any ioctl for
> > > it. There is only ioctl cmd for getting address, not
> > > setting it.
> > > 
> > > #define SIOCETHTOOL 0x8946
> > > 
> > > /* Get permanent hardware address */
> > > #define ETHTOOL_GPERMADDR 0x00000020
> > 
> > Yeah, because it's supposed to be permanent and unchanging. 
> > Which means if there was an ioctl for it, that would be
> > contrary to the purpose of a permanent MAC address.
> > 
> > I realize the N900 stores the WiFi MAC address completely
> > differently than many other systems, and that's why this
> > sysfs file was created.  I don't really have a great
> > converged solution for that, other than what you've currently
> > got, or perhaps adding SPERMADDR to ethtool.  One thing I
> > *would* like though, is a restriction on the sysfs file such
> > that if the permanent MAC is already set, it cannot be set
> > again.  Otherwise the permanent MAC address isn't permanent
> > at all.
> > 
> > Dan
> 
> Maybe another way could be to use request_firmware to load address 
> from userspace... Or what do you think?

That sounds like a great idea to try.  A number of devices either need
stub firmware to read the MAC from EEPROM, or do use request_firmware()
to load firmware before they read the MAC.  You may have to use
request_firmware() synchronously though to ensure that the MAC is read
before registering with mac80211.

Dan


