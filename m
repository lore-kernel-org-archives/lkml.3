Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbaEGOxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:53:01 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:60787 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaEGOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1ERfOXNrfKqMVs-Yz8yJjKKU3L5fjUEOb0Aeyqc37py-BWEg@mail.gmail.com>
References: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
	<20140505152014.GA8551@cerebellum.variantweb.net>
	<1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
	<20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
	<1399328550.2646.5.camel@buesod1.americas.hpqcorp.net>
	<000001cf69c9$5776f330$0664d990$%yang@samsung.com>
	<20140507085743.GA31680@bbox>
	<CAL1ERfOXNrfKqMVs-Yz8yJjKKU3L5fjUEOb0Aeyqc37py-BWEg@mail.gmail.com>
Date: Wed, 7 May 2014 23:52:59 +0900
Message-ID: <CAAmzW4Pn2VUEnQ8FyOaBffqfUiHt6ocLEEvyaJrSKmTjaNp_wQ@mail.gmail.com>
Subject: Re: [PATCH] zram: remove global tb_lock by using lock-free CAS
From: Joonsoo Kim <js1304@gmail.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Weijie Yang <weijie.yang@samsung.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Bob Liu <bob.liu@oracle.com>, Dan Streetman <ddstreet@ieee.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Most popular use of zram is the in-memory swap for small embedded system
>> so I don't want to increase memory footprint without good reason although
>> it makes synthetic benchmark. Alhought it's 1M for 1G, it isn't small if we
>> consider compression ratio and real free memory after boot

We can use bit spin lock and this would not increase memory footprint for 32 bit
platform.

Thanks.
