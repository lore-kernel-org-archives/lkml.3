Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3H1TM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:12:28 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:44810 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3H1TM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:12:27 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Joe Perches <joe@perches.com>, Mischa Jonker <Mischa.Jonker@synopsys.com>
CC: "Vineet.Gupta1@synopsys.com" <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARC: Fix __udelay parentheses
Thread-Topic: [PATCH] ARC: Fix __udelay parentheses
Thread-Index: AQHOpByearkhJREnCEya/f/rlhUouJmq09SAgAAiD5D//+JzgIAAIcHw
Date: Wed, 28 Aug 2013 19:12:22 +0000
Message-ID: <E6BF041E97966E4DB955F0DF883AD2D684F1F648@de02wembxa.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <1377715539.1928.45.camel@joe-AO722>
	 <E6BF041E97966E4DB955F0DF883AD2D684F1F601@de02wembxa.internal.synopsys.com>
 <1377716507.1928.57.camel@joe-AO722>
In-Reply-To: <1377716507.1928.57.camel@joe-AO722>
Accept-Language: nl-NL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.225.2.189]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

> I don't see the loops_per_jiffy initial shift << 32.

loops_per_jiffy * HZ = loops_per_second
loops_per_jiffy * HZ = 1,000,000 * loops_per_us
loops_per_jiffy * HZ * 4295 = 4,295,000 * loops_per_us

loops_per_jiffy * HZ * 4294.967296 = 2^32 * loops_per_us

> > > > -	loops = ((long long)(usecs * 4295 * HZ) *
> > > > -		 (long long)(loops_per_jiffy)) >> 32;
> > > > +	loops = (((long long) usecs) * 4295 * HZ *
> > > > +		  (long long) loops_per_jiffy) >> 32;

> 
> I know that.  It's the use of a signed long long vs the unsigned long long
> that I think wrong.

Yes that is wrong too.

> 
> Why cast a unsigned to a signed?

I don't know, this was in the original file. The issue that I was trying to solve, was that usleep didn't sleep long enough, and that is fixed by this patch. 

Wrt signed/unsigned: would you like me to update this patch or create a separate one?

Mischa
