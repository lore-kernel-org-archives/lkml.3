Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaCZJnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:43:51 -0400
Received: from mx0.aculab.com ([213.249.233.131]:39251 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750956AbaCZJnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:43:50 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Cody P Schafer'" <cody@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7
 interface
Thread-Topic: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7
 interface
Thread-Index: AQHPSFiWjqiJ3SqT8EmaHwjaR2yLrprzHYVg
Date: Wed, 26 Mar 2014 09:43:02 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E93BC@AcuExch.aculab.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
 <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com>
 <20140325214356.4a2f7d95@kryten> <5331CBB0.8080500@linux.vnet.ibm.com>
In-Reply-To: <5331CBB0.8080500@linux.vnet.ibm.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2Q9hx5N028231

From: Cody P Schafer
> On 03/25/2014 03:43 AM, Anton Blanchard wrote:
> >
> > Hi Cody,
> >
> > hv-24x7: could not obtain capabilities, error 0x
> fffffffffffffffe, not enabling
> > hv-gpci: could not obtain capabilities, error 0x
> fffffffffffffffe, not enabling
> >
> >> +		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
> >
> > That's a lot of padding :)
> >
> > I think this should also be a pr_debug, considering this is not relevant
> > to most ppc64 boxes.
> 
> Yep, s/info/debug/ makes sense. The format should have been "%08lx" not
> "%80lx", not sure when I screwed that up.

Using "%#x" is an alternative - unless you really need fixed width.

However in this case "%ld" might be more appropriate!
If the value is a -ve errno one, maybe even "errno %d" and negate the value.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
