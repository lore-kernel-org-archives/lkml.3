Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3J2Nfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:35:33 -0400
Received: from purkki.adurom.net ([80.68.90.206]:40748 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab3J2Nfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:35:32 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 03/16] wl1251: add sysfs interface for bluetooth coexistence mode configuration
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1382819655-30430-4-git-send-email-pali.rohar@gmail.com>
	<1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
	<1383030565.21526.92.camel@porter.coelho.fi>
Date: Tue, 29 Oct 2013 15:35:20 +0200
In-Reply-To: <1383030565.21526.92.camel@porter.coelho.fi> (Luca Coelho's
	message of "Tue, 29 Oct 2013 09:09:25 +0200")
Message-ID: <878uxctd2f.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> On Mon, 2013-10-28 at 23:39 +0000, Ben Hutchings wrote:
>> On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
>> > From: David Gnedt <david.gnedt@davizone.at>
>> > 
>> > Port the bt_coex_mode sysfs interface from wl1251 driver version included
>> > in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
>> > This enables userspace applications to set one of the modes
>> > WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
>> > The default mode is WL1251_BT_COEX_OFF.
>> > It should be noted that this driver always enabled bt-coexistence before
>> > and enabled bt-coexistence directly affects the receiving performance,
>> > rendering it unusable in some low-signal situations. Especially monitor
>> > mode is affected very badly with bt-coexistence enabled.
>> [...]
>> 
>> This should be implemented consistently with other drivers:
>> 
>> drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
>> drivers/net/wireless/ath/ath9k/init.c:module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
>> drivers/net/wireless/b43/main.c:module_param_named(btcoex, modparam_btcoex, int, 0444);
>> drivers/net/wireless/ipw2x00/ipw2200.c:module_param(bt_coexist, int, 0444);
>> drivers/net/wireless/iwlegacy/common.c:module_param(bt_coex_active, bool, S_IRUGO);
>> drivers/net/wireless/iwlwifi/iwl-drv.c:module_param_named(bt_coex_active, iwlwifi_mod_params.bt_coex_active,
>> drivers/net/wireless/ti/wlcore/sysfs.c:static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
>> 
>> Oh, hmm, I see a problem here.
>
> With so many drivers doing the same thing, isn't it about time to add
> this to nl80211?

Yes, this really needs to be in nl80211. I even suggested this years ago
but was turned down at the time. Can't remember the reason anymore.

-- 
Kalle Valo
