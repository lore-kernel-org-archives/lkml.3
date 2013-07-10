Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3GJPRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:17:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:10160 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3GJPRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1036,1363158000"; 
   d="scan'208";a="266453805"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Subject: RE: [Intel-gift] Linux 3.10-rc7
Thread-Topic: [Intel-gift] Linux 3.10-rc7
Thread-Index: Ac59gJi9domNTZLbT4OS9A/79ZioNQ==
Date: Wed, 10 Jul 2013 15:17:31 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028E5075@HASMSX106.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > suspend complete.
> >
> > I can start bi-sect of this problem on intel-display scope if you
> > would like me to. Please let me know if the bisect scope should be larger.
> >
> > -- Shuah
> 
> I got finally an older system where this reproduces consistently, I'm trying to
> root cause that now.
> As soon I have something to test I will send it out.
>

I'm not sure why but I'm not able to get the interrupt from the device until all the devices has resumed after that the mei reset is successful and device work as expected.
I need to fix the state machine so the reset won't go crazy on resetting  actually I did that and it reduces resets into two but I'm still trying to figure out what's going on.
The regression coming from the fact that I've linearize the reset flow, it waits for interrupt to arrive, before that the flow gave up and  has restarted directly from the interrupt thread.


Thanks
Tomas 

