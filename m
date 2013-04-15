Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3DONiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:38:13 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5827 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab3DONiM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:38:12 -0400
From: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>
To: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonymobile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        Brian Swetland <swetland@google.com>
Date: Mon, 15 Apr 2013 15:38:08 +0200
Subject: RE: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Topic: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Index: Ac4527OoDwFt+xI9TnKGmvBhhFG55AAACjNQ
Message-ID: <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
In-Reply-To: <20130415131815.GG6638@mwanda>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, sv-SE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Where is lowmem_shrink called from?  I only see shrink called from the
>bcache sysfs handler __bch_cache_set().  The return value isn't checked
>there.
>
>Up to now this function has only returns positive numbers.
>
>There isn't a place which check LMK_BUSY so maybe it's best to just
>return zero?

Hey Dan,

lowmem_shrink is assigned to a shrinker struct (include/linux/shrinker.h) and called in do_shrinker_shrink() in mm/vmscan.c. That, in turn, is called and checked in a few places in vmscan.c.
	
>From the comments in shrinker.h: 
"It should return the number of objects which remain in the cache. If it returns -1, it means it cannot do any scanning at this time (eg. there is a risk of deadlock). The callback must not return -1 if nr_to_scan is zero."

//Snild
