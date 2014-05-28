Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaE1HOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:14:54 -0400
Received: from outm2.farsite.co.uk ([82.108.209.243]:46048 "EHLO m.farsite.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbaE1HOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:14:52 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 03:14:51 EDT
From: Kevin Curtis <Kevin.Curtis@farsite.com>
To: David Miller <davem@davemloft.net>, "joe@perches.com" <joe@perches.com>
CC: "manuel.schoelling@gmx.de" <manuel.schoelling@gmx.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 28 May 2014 08:09:19 +0100
Subject: RE: [PATCH] wan: time_before()
Thread-Topic: [PATCH] wan: time_before()
Thread-Index: Ac94nK7pwQ9LZtnhSCyRsoZtmhtQZwBpvliw
Message-ID: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223C6D@SOLO.hq.farsitecommunications.com>
References: <1401039163-10727-1-git-send-email-manuel.schoelling@gmx.de>
	<1401040732.22191.8.camel@joe-AO725>
 <20140526.004045.1779020170437806699.davem@davemloft.net>
In-Reply-To: <20140526.004045.1779020170437806699.davem@davemloft.net>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    Yes, a usleep(10) would be just fine.


Regards

Kevin

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: 26 May 2014 05:41
To: joe@perches.com
Cc: manuel.schoelling@gmx.de; Kevin Curtis; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] wan: time_before()

From: Joe Perches <joe@perches.com>
Date: Sun, 25 May 2014 10:58:52 -0700

> On Sun, 2014-05-25 at 19:32 +0200, Manuel Schölling wrote:
>> To be future-proof and for better readability the time comparisons 
>> are modified to use time_before() instead of plain, error-prone math.
> 
> Sensible change, but it seems these should be
> udelay(some_constant) instead of a a rather variable time wait based 
> on a system/config defined jiffies.

Agreed, this code probably wants udelay(10) or something like that.
