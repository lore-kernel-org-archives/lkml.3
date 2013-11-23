Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab3KWFmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:42:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:33620 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3KWFmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:42:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,757,1378882800"; 
   d="scan'208";a="438436979"
From: "Hart, Darren" <darren.hart@intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "efault@gmx.de" <efault@gmx.de>, "jeffm@suse.com" <jeffm@suse.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "scott.norton@hp.com" <scott.norton@hp.com>,
        "tom.vaden@hp.com" <tom.vaden@hp.com>, "aswin@hp.com" <aswin@hp.com>,
        "Waiman.Long@hp.com" <Waiman.Long@hp.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>
Subject: Re: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
Thread-Topic: [PATCH 4/5] futex: Avoid taking hb lock if nothing to wakeup
Thread-Index: AQHO6A6+Nu+s7aUDu0GW3upOj6D4AA==
Date: Sat, 23 Nov 2013 05:42:07 +0000
Message-ID: <1385185326.29354.167.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
	 <1385168197-8612-5-git-send-email-davidlohr@hp.com>
	 <1385185207.29354.166.camel@dvhart-mobl4.amr.corp.intel.com>
In-Reply-To: <1385185207.29354.166.camel@dvhart-mobl4.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.15.62]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ABE4EE374EDD74EA9205DCC4715D1C6@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAN5gJmE027008

On Fri, 2013-11-22 at 21:40 -0800, Darren Hart wrote:
> On Fri, 2013-11-22 at 16:56 -0800, Davidlohr Bueso wrote:
> > In futex_wake() there is clearly no point in taking the hb->lock if
> > we know beforehand that there are no tasks to be woken. This comes
> > at the smaller cost of doing some atomic operations to keep track of
> > the list's size. Specifically, increment the counter when an element is
> > added to the list, and decrement when it is removed. Of course, if the
> > counter is 0, then there are no tasks blocked on a futex. Some special
> > considerations:
> > 
> > - increment the counter at queue_lock() as we always end up calling
> >   queue_me() which adds the element to the list. Upon any error,
> >   queue_unlock() is called for housekeeping, for which we decrement
> >   to mach the increment done in queue_lock().
> > 
> > - decrement the counter at __unqueue_me() to reflect when an element is
> >   removed from the queue for wakeup related purposes.
> 
> What is the problem you are trying to solve here?

Apologies, too quick on the trigger. I see plenty of detail in 0/5. Will
spend some time reviewing that.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
