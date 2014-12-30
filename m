Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaL3U2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 15:28:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:3630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL3U2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 15:28:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="435075817"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "jkosina@suse.cz" <jkosina@suse.cz>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Topic: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Index: AQHQJDU+EoR5axQUzE2MSpVrm+daTJyoDkqAgAADSYCAACHJYP//6zeAgABVzQA=
Date: Tue, 30 Dec 2014 20:28:23 +0000
Message-ID: <1419971304.30412.0.camel@egrumbacBox>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
	 <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
	 <54A2B807.1020202@hurleysoftware.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
	 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.147.25]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D62A0347C5CD1418A7EA9308A73D7DD@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBUKT90K021889

On Tue, 2014-12-30 at 16:21 +0100, Jiri Kosina wrote:
> On Tue, 30 Dec 2014, Grumbach, Emmanuel wrote:
> 
> > > > So why do you used them?
> > > > They have been deprecated for a couple of years now. You should be
> > > > using nl80211 based tools such as iw.
> > > 
> > > A couple of years is not very long where userspace is concerned.
> > > 
> > Well - the decently new wireless tools do talk nl80211.
> 
> With 3.18-rc5, I get this:
> 
> # iwconfig --version
> iwconfig  Wireless-Tools version 30
>           Compatible with Wireless Extension v11 to v22.
> 
> Kernel    Currently compiled with Wireless Extension v22.
> 
> wlan0     Recommend Wireless Extension v21 or later,
>           Currently compiled with Wireless Extension v22.
> 
> 
> With 3.19-rc, I get (with the same userspace) this:
> 
> # iwconfig --version
> iwconfig  Wireless-Tools version 30
>           Compatible with Wireless Extension v11 to v22.
> 
>           Cannot read /proc/net/wireless
> 
> And nothing else (iwlist, etc) works either. This is with
> 
> # rpm -qi wireless-tools | grep Ver
> Version     : 30.pre9
> 
> from openSUSE 13.2. That's not decently new enough?
> 

You should also have the iw tool which will provide all you need
using the nl80211 interface which is now the preferred interface.

> > You can still enable it (CFG80211_WEXT).
> > It has been disabled by:
> > 
> > commit 24a0aa212ee2dbe44360288684478d76a8e20a0a
> > Author: Johannes Berg <johannes.berg@intel.com>
> > Date:   Fri Nov 28 12:14:06 2014 +0100
> >
> >    cfg80211: make WEXT compatibility unselectable
> 
> I think this needs to be reverted.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
