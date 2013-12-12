Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3LLK4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:56:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55943 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3LLK4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:56:51 -0500
Date: Thu, 12 Dec 2013 11:56:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Dan Williams <dcbw@redhat.com>, Kalle Valo <kvalo@adurom.com>,
        Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
Message-ID: <20131212105647.GA22471@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <201312101814.35112@pali>
 <1386697762.30202.6.camel@dcbw.foobar.com>
 <201312101852.17030@pali>
 <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-12-11 21:17:34, Ben Hutchings wrote:
> On Tue, 2013-12-10 at 18:52 +0100, Pali Rohár wrote:
> > On Tuesday 10 December 2013 18:49:22 Dan Williams wrote:
> > > On Tue, 2013-12-10 at 18:14 +0100, Pali Rohár wrote:
> > > > On Tuesday 10 December 2013 17:10:50 Pali Rohár wrote:
> > > > > On Tuesday 10 December 2013 16:49:23 Kalle Valo wrote:
> > > > > > Pali Rohár <pali.rohar@gmail.com> writes:
> > > > > > > Driver wl1251 generating mac address randomly at
> > > > > > > startup and there is no way to set permanent mac
> > > > > > > address via SET_IEEE80211_PERM_ADDR. This patch
> > > > > > > export sysfs file which can set permanent mac address
> > > > > > > by userspace helper program. Patch is needed for
> > > > > > > devices which do not store mac address in internal
> > > > > > > wl1251 eeprom.
> > > > > > > 
> > > > > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > > > 
> > > > > > We have ioctl() command for setting the mac address.
> > > > > 
> > > > > Really? Is there ioctl for setting permanent mac address?
> > > > > Can you show me it?
> > > > 
> > > > Now I looked at it again and I did not found any ioctl for
> > > > it. There is only ioctl cmd for getting address, not
> > > > setting it.
> > > > 
> > > > #define SIOCETHTOOL 0x8946
> > > > 
> > > > /* Get permanent hardware address */
> > > > #define ETHTOOL_GPERMADDR 0x00000020
> > > 
> > > Yeah, because it's supposed to be permanent and unchanging. 
> > > Which means if there was an ioctl for it, that would be
> > > contrary to the purpose of a permanent MAC address.
> > > 
> > > I realize the N900 stores the WiFi MAC address completely
> > > differently than many other systems, and that's why this
> > > sysfs file was created.  I don't really have a great
> > > converged solution for that, other than what you've currently
> > > got, or perhaps adding SPERMADDR to ethtool.  One thing I
> > > *would* like though, is a restriction on the sysfs file such
> > > that if the permanent MAC is already set, it cannot be set
> > > again.  Otherwise the permanent MAC address isn't permanent
> > > at all.
> 
> I'm really uncomfortable with the idea of involving userland in
> establishing the 'permanent' MAC address.  (And from what I gather, the
> Nokia software never did that but only used SIOCSIFHWADDR.)  It ought to
> be set before the interface is ever registered.

Which is hard to do on n900. What is the problem with userland setting
permanent mac address?

It is not used for security or anything...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
