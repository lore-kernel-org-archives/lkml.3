Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab3DOS2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:28:11 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:3079 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab3DOS2K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:28:10 -0400
From: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>
To: =?iso-8859-1?Q?=22Ander=F6=2C_Oskar=22?= 
	<Oskar.Andero@sonymobile.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>
Date: Mon, 15 Apr 2013 20:28:07 +0200
Subject: RE: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Topic: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Thread-Index: Ac456nR+TVc8rIwYSHuZnIAbAE+vUgAGmPMg
Message-ID: <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda> <20130415150356.GA22161@caracas.corpusers.net>
In-Reply-To: <20130415150356.GA22161@caracas.corpusers.net>
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

>> > >From the comments in shrinker.h:
>> > "It should return the number of objects which remain in the cache.
>> > If it returns -1, it means it cannot do any scanning at this time
>> > (eg. there is a risk of deadlock). The callback must not return -1
>> > if nr_to_scan is zero."
>>
>
>IMO one should use the errno.h values - e.g. EBUSY might be a good value
>in this case. Does anyone know why the shrinker wants -1? Is there a
>reason?

The positive numbers are used to return information on the remaining cache size (again, see the comment I pasted above). We could use -EBUSY, but we'd have to change vmscan.c, which checks specifically for -1. I can't see a technical reason why -EBUSY couldn't have been chosen instead, but there's also no real reason to change it now.

//Snild
