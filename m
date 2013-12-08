Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab3LHQgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 11:36:12 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:42623 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3LHQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 11:36:08 -0500
Message-ID: <1386520563.12186.13.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 03/16] wl1251: add sysfs interface for bluetooth
 coexistence mode configuration
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
        <joni.lapilainen@gmail.com>, David Gnedt <david.gnedt@davizone.at>
Date: Sun, 8 Dec 2013 16:36:03 +0000
In-Reply-To: <201312080855.24999@pali>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-4-git-send-email-pali.rohar@gmail.com>
	 <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
	 <201312080855.24999@pali>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20344.006
X-TM-AS-Result: No--16.353300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 08:55 +0100, Pali Rohár wrote:
> On Tuesday 29 October 2013 00:39:47 Ben Hutchings wrote:
> > On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> > > From: David Gnedt <david.gnedt@davizone.at>
> > > 
> > > Port the bt_coex_mode sysfs interface from wl1251 driver
> > > version included in the Maemo Fremantle kernel to allow
> > > bt-coexistence mode configuration. This enables userspace
> > > applications to set one of the modes WL1251_BT_COEX_OFF,
> > > WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO. The
> > > default mode is WL1251_BT_COEX_OFF.
> > > It should be noted that this driver always enabled
> > > bt-coexistence before and enabled bt-coexistence directly
> > > affects the receiving performance, rendering it unusable in
> > > some low-signal situations. Especially monitor mode is
> > > affected very badly with bt-coexistence enabled.
> > 
> > [...]
> > 
> > This should be implemented consistently with other drivers:
> > 
> > drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_nam
> > ed(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
> > drivers/net/wireless/ath/ath9k/init.c:module_param_named(btco
> > ex_enable, ath9k_btcoex_enable, int, 0444);
> > drivers/net/wireless/b43/main.c:module_param_named(btcoex,
> > modparam_btcoex, int, 0444);
> > drivers/net/wireless/ipw2x00/ipw2200.c:module_param(bt_coexis
> > t, int, 0444);
> > drivers/net/wireless/iwlegacy/common.c:module_param(bt_coex_a
> > ctive, bool, S_IRUGO);
> > drivers/net/wireless/iwlwifi/iwl-drv.c:module_param_named(bt_
> > coex_active, iwlwifi_mod_params.bt_coex_active,
> > drivers/net/wireless/ti/wlcore/sysfs.c:static
> > DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
> > 
> > Oh, hmm, I see a problem here.
> > 
> > Ben.
> 
> So where is consitency? Each driver doing this in different way:
> btcoex_enable, btcoex, bt_coexist, bt_coex_active

Indeed, it's a bigger problem than one driver and this isn't really an
objection to your patch.  I suppose there should be an nl80211 attribute
to control this behaviour per-interface.  You or any other wireless
networking developer could work on that.

Ben.

> Reason for this usage in wl1251 is to not break existing 
> userspace applications.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

