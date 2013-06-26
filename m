Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3FZWLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:11:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:30112 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3FZWLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,947,1363158000"; 
   d="scan'208";a="360135230"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: RE: Linux 3.10-rc7
Thread-Topic: Linux 3.10-rc7
Thread-Index: AQHOcO9Wy94BEELWoUiZdIX6E3dp15lIkLZQ
Date: Wed, 26 Jun 2013 22:11:13 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028DB36B@HASMSX106.ger.corp.intel.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
 <CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
 <CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
 <20130625125437.6e7bb2d4@jbarnes-desktop>
 <B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
 <20130625130816.55e6cb80@jbarnes-desktop>
 <B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
 <CA+i0qc64MqeZd3y2E4YOtxwxyWRPXqofJep1BGCeEHCdkJuxQg@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E6173079B@sisaex02sj>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6173079B@sisaex02sj>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Can you please send me the log part when this starts?
> >
> > Thanks
> >
> 
> It rolled over and I don't have prior messages. I tried reproducing twice and
> didn't see it again. I will try a few more times and see if I can get it to happen
> again.
> 
> This is what I could save before dmesg rolled over:
> 
> [   78.709014] mei_me 0000:00:16.0: reset: wrong host start response
> [   78.709016] mei_me 0000:00:16.0: unexpected reset: dev_state =
> RESETTING
> [   78.709029] mei_me 0000:00:16.0: reset: unexpected enumeration
> response hbm.
> [   78.709031] mei_me 0000:00:16.0: unexpected reset: dev_state =
> RESETTING
> [   78.709069] mei_me 0000:00:16.0: reset: wrong host start response
> 
So far I was able to positively reproduce it with  3.10-rc5 but not with 3.10-rc7 and above.

There are 3 patches that went in to fix this issue

42f132f mei: me: clear interrupts on the resume path
2753ff5 mei: nfc: fix nfc device freeing
5e85b36 mei: init: Flush scheduled work before resetting the device

Are you sure you have these 3 in?

Thanks
Tomas
