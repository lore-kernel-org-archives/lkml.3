Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaCFJNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:13:46 -0500
Received: from mx0.aculab.com ([213.249.233.131]:38294 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751095AbaCFJNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:13:43 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>
Subject: RE: [PATCH] phy: fix compiler array bounds warning on settings[]
Thread-Topic: [PATCH] phy: fix compiler array bounds warning on settings[]
Thread-Index: AQHPOAruIxtn6MjoSU2S08w3Vpy7W5rSNHzAgADFiYCAAM0toA==
Date: Thu, 6 Mar 2014 09:13:09 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D38E1@AcuExch.aculab.com>
References: <20140305003544.23016.55079.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6D1440@AcuExch.aculab.com>
 <CAErSpo6hUVc_2MP85CM3-qvOmdSBUJ1bxn+RiXqymJpTwQLzfg@mail.gmail.com>
In-Reply-To: <CAErSpo6hUVc_2MP85CM3-qvOmdSBUJ1bxn+RiXqymJpTwQLzfg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s269DqFk024152

From: Bjorn Helgaas
> I'm stumped.  phy_find_valid() is static and only called from one
> place.  The 'idx' argument is always the result of phy_find_setting(),
> which should always return something between 0 and
> ARRAY_SIZE(settings), so I don't see any way idx can be < 0.
> 
> I stripped this down as far as I could; the resulting test code is at
> http://pastebin.com/pp1zMEWu if anybody else wants to look at it.  I'm
> using gcc 4.8.x 20131105 (prerelease), with "-Warray-bounds -O2"
> flags.
> 
> I hesitate to suspect a compiler bug, but it is very strange.  For
> example, in my test code, replacing "MAX_NUM_SETTINGS" with "2" gets
> rid of the warnings.  MAX_NUM_SETTINGS is known to be 2 at
> compile-time, so I don't know why this should make a difference.

I can't get an array bounds error from the gcc 4.8.1-10ubuntu9 at all.
Not even when I index the array with a constant 3.
I wonder if they compiled it out!

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
