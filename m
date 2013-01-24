Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3AXQTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:19:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:62894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3AXQTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:19:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,530,1355126400"; 
   d="scan'208";a="251831696"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Kettenis <kettenis@gnu.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        "gdb-patches@sourceware.org" <gdb-patches@sourceware.org>
Subject: RE: [PATCH] x86, perf, bts: disable BTS from Nehalem to Ivy Bridge
Thread-Topic: [PATCH] x86, perf, bts: disable BTS from Nehalem to Ivy Bridge
Thread-Index: AQHN+koPtQ7h4eFQpEO6XdiO7PVjgJhYoJ1g
Date: Thu, 24 Jan 2013 16:17:26 +0000
Message-ID: <A78C989F6D9628469189715575E55B2307B648E7@IRSMSX102.ger.corp.intel.com>
References: <1354876511-25294-1-git-send-email-markus.t.metzger@intel.com>
 <20130124154637.GB32146@gmail.com>
In-Reply-To: <20130124154637.GB32146@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: gdb-patches-owner@sourceware.org [mailto:gdb-patches-owner@sourceware.org] On Behalf Of Ingo Molnar
> Sent: Thursday, January 24, 2013 4:47 PM


> > Starting with Nehalem, the BTS "from" information may in some cases be
> > incorrect (AAJ122).
> >
> > This has been detected while adding branch tracing support to gdb, where it
> > results in sporadic test fails.
> >
> > Disable BTS support on Nehalem, Westmere, Sandy Bridge, and Ivy Bridge.
> 
> But the failures are rare, so the BTS data is still correct
> statistically, by and large, right? So why not just keep it
> as-is and teach tooling to be more robust about implausible
> trace entries? It has to be ready for that eventuality *anyway*.

Yes, the fails are rare. They are frequent enough, however, to cause sporadic test fails.

The problem is that you can't reliably detect such fails. In the worst case, GDB would show wrong but plausible trace. Typically, GDB just shows garbage (i.e. impossible trace) in such cases.

I'm afraid one might endlessly debate whether the feature as-is is useful or not. It is working fine on Atom so I chose to disable it on core.

The GDB folks would rather not disable the feature inside GDB; they prefer that it is disabled in the kernel. There will be an additional check inside GDB to support older kernel versions.

Regards,
markus.
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

