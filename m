Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaL3PVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:21:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaL3PVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:21:22 -0500
Date: Tue, 30 Dec 2014 16:21:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: Peter Hurley <peter@hurleysoftware.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: iwlwifi-driver card doesn't work with 3.19-rc2+
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2014, Grumbach, Emmanuel wrote:

> > > So why do you used them?
> > > They have been deprecated for a couple of years now. You should be
> > > using nl80211 based tools such as iw.
> > 
> > A couple of years is not very long where userspace is concerned.
> > 
> Well - the decently new wireless tools do talk nl80211.

With 3.18-rc5, I get this:

# iwconfig --version
iwconfig  Wireless-Tools version 30
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v21 or later,
          Currently compiled with Wireless Extension v22.


With 3.19-rc, I get (with the same userspace) this:

# iwconfig --version
iwconfig  Wireless-Tools version 30
          Compatible with Wireless Extension v11 to v22.

          Cannot read /proc/net/wireless

And nothing else (iwlist, etc) works either. This is with

# rpm -qi wireless-tools | grep Ver
Version     : 30.pre9

from openSUSE 13.2. That's not decently new enough?

> You can still enable it (CFG80211_WEXT).
> It has been disabled by:
> 
> commit 24a0aa212ee2dbe44360288684478d76a8e20a0a
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Nov 28 12:14:06 2014 +0100
>
>    cfg80211: make WEXT compatibility unselectable

I think this needs to be reverted.

-- 
Jiri Kosina
SUSE Labs
