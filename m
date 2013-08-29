Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3H2GtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:49:13 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:61540 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3H2GtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:49:12 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Joe Perches <joe@perches.com>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
Thread-Topic: [PATCH] ARC: Fix __udelay parentheses
Thread-Index: AQHOpByfrbiZ1kbBskyi3sxdeiKfdQ==
Date: Thu, 29 Aug 2013 06:49:07 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075140F85@IN01WEMBXA.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
	 <1377756078.1928.89.camel@joe-AO722>
	 <C2D7FE5348E1B147BCA15975FBA23075140F41@IN01WEMBXA.internal.synopsys.com>
 <1377758224.1928.91.camel@joe-AO722>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 12:07 PM, Joe Perches wrote:
>> On the topic of multiply vs. divide (which probably is not relevant to topic at
>> hand though), since ARCompact doesn't have native divide, we end up emulating it
>> using libgcc routines. That makes it slightly non-deterministic (not a big deal)
>> and also adds to boot time (which those delays sprinkled all over the place in
>> crazy device probes and such). Seriously we got hammered by a customer for that once.
> That argues more for reducing the uses of hard delays
> than making the hard delay count calculation simpler.

Right, but most often the drivers are written/maintained by non arch people.

I'm with you in terms of simplification and I think the following

loops = ((u64)usecs * 4295 * HZ * loops_per_jiffy) >> 32;

is fairly simple, well commented, and optimal for ARC.

-Vineet
