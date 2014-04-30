Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbaD3JbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:31:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:61359 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933533AbaD3Ja6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:30:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,957,1389772800"; 
   d="scan'208";a="523672229"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lib/spinlock_debug: Tweak the loop time to fit
 different _delay()
Thread-Topic: [PATCH] lib/spinlock_debug: Tweak the loop time to fit
 different _delay()
Thread-Index: AQHPZFH3REk4aQxP/UWEe+6fYgBcs5sp5JyA
Date: Wed, 30 Apr 2014 09:30:55 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01D053BC@SHSMSX101.ccr.corp.intel.com>
References: <1398897638.21870.8.camel@wxm-ubuntu>
 <20140430085508.GE30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140430085508.GE30445@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, April 30, 2014 4:55 PM
> To: Wang, Xiaoming
> Cc: mingo@redhat.com; linux-kernel@vger.kernel.org; Liu, Chuansheng
> Subject: Re: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
> _delay()
> 
> On Wed, Apr 30, 2014 at 06:40:38PM -0400, Wang, Xiaoming wrote:
> > loops_per_jiffy*Hz  is not always 1 second exactly
> > it depends on the realization of _delay() .
> > delay_tsc is used as _delay() in arch/x86/lib/delay.c
> 
> This just states delay() is broken. The primary response should be to
> try and fix that, no?


delay(1s_count) is accurate, but delay(1) is not accurate indeed, since executing
some instruction, then the 1 cycle delay maybe be used already.

