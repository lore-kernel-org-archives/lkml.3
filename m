Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3FENuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:50:11 -0400
Received: from mx0.aculab.com ([213.249.233.131]:46462 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755026Ab3FENuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:50:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v9 net-next 5/7] net: simple poll/select low latency socket poll
Date: Wed, 5 Jun 2013 14:49:31 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7270@saturn3.aculab.com>
In-Reply-To: <1370439054.24311.248.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v9 net-next 5/7] net: simple poll/select low latency socket poll
Thread-Index: Ac5h8Sh1ZUr2c9CVQ/C4+bzCYCNCHAAAO/aw
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com> <20130605103452.11172.31453.stgit@ladj378.jer.intel.com> <1370439054.24311.248.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Eliezer Tamir" <eliezer.tamir@linux.intel.com>
Cc: "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        "Willem de Bruijn" <willemb@google.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "Andi Kleen" <andi@firstfloor.org>, "HPA" <hpa@zytor.com>,
        "Eilon Greenstien" <eilong@broadcom.com>,
        "Or Gerlitz" <or.gerlitz@gmail.com>, "Amir Vadai" <amirv@mellanox.com>,
        "Eliezer Tamir" <eliezer@tamir.org.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r55DoSL8029514

> I am a bit uneasy with this one, because an applicatio polling() on one
> thousand file descriptors using select()/poll(), will call sk_poll_ll()
> one thousand times.

Anything calling poll() on 1000 fds probably has performance
issues already! Which is why kevent schemes have been added.

At least the Linux code doesn't use a linked list for
the fd -> 'struct file' map which made poll() O(n^2),
and getting to that number of open fds O(n^3) on
some versions of SVR4.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
