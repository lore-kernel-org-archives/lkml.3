Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaLaHu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 02:50:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:59925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaLaHuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 02:50:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="435235591"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Topic: iwlwifi-driver card doesn't work with 3.19-rc2+
Thread-Index: AQHQJDU+EoR5axQUzE2MSpVrm+daTJyoDkqAgAADSYCAACHJYP//6zeAgABVzQCAAAO2gIAAC6oAgAAUNgCAAAH3AIAAuNUw
Date: Wed, 31 Dec 2014 07:50:19 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5DD429@hasmsx107.ger.corp.intel.com>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
 <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
 <54A2B807.1020202@hurleysoftware.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com>
 <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz>
 <1419971304.30412.0.camel@egrumbacBox>
 <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
 <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Tue, 30 Dec 2014, Larry Finger wrote:
> 
> > > > If wireless maintainers think otherwise, I'll send a revert
> > > > request to Linus for consideration.
> > >
> > > I wonder if the reaction would be like this one:
> > >
> > > https://lkml.org/lkml/2012/12/23/75
> > >
> > > :-)
> >
> > It would be a little like that.
> >
> > One thread of interest is https://lkml.org/lkml/2014/12/22/348. Commit
> > 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable") made
> > it impossible to select the IPW2200. The patch to allow selecting the
> > IPW2200, which automatically selects CFG80211_WEXT has been added to
> > wireless-drivers, but it has not yet made it to mainline. Once it
> > does, then choosing to build the IPW2200 will provide a workaround.
> >
> > In my opinion, the need for the IPW2200 to have CFG80211_WEXT means
> > that the original commit will likely be reverted, but your voice will help.
> 
> Ok, thanks a lot for another datapoint. I am sending revert patch to Linus
> tonight.
> 
I don't see this as another datapoint. All it means is that there are ancient drivers
that won't work at all with newer tools and that are taken into consideration while
trying to deprecate an API.
Now - basically all your argument is on Johannes's comment: "deprecated enough".
I think we have a chicken and egg problem here. We can't break things towards userland.
Good. But we do want to deprecate this API because lots of valid purely technical reasons.
Unfortunately, I don't see what we could do to send a strong signal to userspace tools developers
to have them work / plan a move to a modern API.
