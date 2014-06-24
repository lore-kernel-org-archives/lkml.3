Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaFXOkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:40:46 -0400
Received: from mx0.aculab.com ([213.249.233.131]:34015 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753921AbaFXOkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:40:45 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexey Kardashevskiy'" <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio: Fix endianness handling for emulated BARs
Thread-Topic: [PATCH] vfio: Fix endianness handling for emulated BARs
Thread-Index: AQHPj7lOvm3ulD4XbEqGzGoVRPxJOZuAU8wQ
Date: Tue, 24 Jun 2014 14:40:07 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17263229@AcuExch.aculab.com>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
		 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
		 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
		 <1403234514.3707.278.camel@ul30vt.home> <1403305961.4587.66.camel@pasglop>
	 <53A94EBD.101@ozlabs.ru> <53A955F5.6050801@suse.de>
	 <53A9741B.1040500@ozlabs.ru> <53A97486.4070604@suse.de>
	 <53A976B7.3070709@ozlabs.ru> <53A97BA9.4020702@suse.de>
 <1403619685.16078.15.camel@ul30vt.home> <53A98C38.8020205@ozlabs.ru>
In-Reply-To: <53A98C38.8020205@ozlabs.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5OEeonD028620

From: Alexey Kardashevskiy
...
> >> So IMHO we should either create new, generic iowrite helpers that don't
> >> do any endian swapping at all or do iowrite32(cpu_to_le32(val)) calls.
> >
> > I'm one of those people for whom iowrite32(le32_to_cpu(val)) makes sense
> 
> 
> I do not understand why @val is considered LE here and need to be converted
> to CPU. Really. I truly believe it should be cpu_to_le32().

Think about it carefully...

Apparently iowrite32() is writing a 'cpu' value out 'le'.
So if you have a 'le' value you need to convert it to 'cpu' first.

I really won't ask how 'be' ppc managed to get 'le' on-chip peripherals.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
