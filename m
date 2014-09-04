Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaIDIoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 04:44:30 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47794 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756638AbaIDIo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 04:44:26 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
CC: Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>
Subject: RE: bit fields && data tearing
Thread-Topic: bit fields && data tearing
Thread-Index: AQHPx8xmJXKiC/P/tUa9IYpE5+LVuZvwqAQg
Date: Thu, 4 Sep 2014 08:43:13 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com>
References: <20140712181328.GA8738@redhat.com>
 <54079B70.4050200@hurleysoftware.com> <1409785893.30640.118.camel@pasglop>
In-Reply-To: <1409785893.30640.118.camel@pasglop>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s848ifM8008450

From:  Benjamin Herrenschmidt
> On Wed, 2014-09-03 at 18:51 -0400, Peter Hurley wrote:
> 
> > Apologies for hijacking this thread but I need to extend this discussion
> > somewhat regarding what a compiler might do with adjacent fields in a structure.
> >
> > The tty subsystem defines a large aggregate structure, struct tty_struct.
> > Importantly, several different locks apply to different fields within that
> > structure; ie., a specific spinlock will be claimed before updating or accessing
> > certain fields while a different spinlock will be claimed before updating or
> > accessing certain _adjacent_ fields.
> >
> > What is necessary and sufficient to prevent accidental false-sharing?
> > The patch below was flagged as insufficient on ia64, and possibly ARM.
> 
> We expect native aligned scalar types to be accessed atomically (the
> read/modify/write of a larger quantity that gcc does on some bitfield
> cases has been flagged as a gcc bug, but shouldn't happen on normal
> scalar types).

That isn't true on all architectures for items smaller than a machine word.
At least one has to do rmw for byte accesses.

	David

> I am not 100% certain of "bool" here, I assume it's treated as a normal
> scalar and thus atomic but if unsure, you can always use int.
> 
> Another option is to use the atomic bitops and make these bits in a
> bitmask but that is probably unnecessary if you have locks already.
> 
> Cheers,
> Ben.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
