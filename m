Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaGVAdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:33:04 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:42007 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaGVAdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:33:02 -0400
Message-ID: <1405989175.25048.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
Date: Mon, 21 Jul 2014 17:32:55 -0700
In-Reply-To: <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com>
	 <CFF29A00.9D44A%dvhart@linux.intel.com>
	 <CFF29E4A.9D44E%dvhart@linux.intel.com>
	 <alpine.DEB.2.10.1407212025130.20847@nanos> <20140721212740.GS3935@laptop>
	 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 14:31 -0700, Andy Lutomirski wrote:
> On Mon, Jul 21, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > All this is predicated on the fact that syscalls are 'expensive'.
> > Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> > more expensive due to cacheline misses, which due to the size of the
> > things is almost guaranteed.
> 
> 120 - 300 cycles for me, unless tracing happens, and I'm working on
> reducing the incidence of tracing.

fwiw here's what lmbench's lat_ctx says on my system . For 'accuracy', I
kept the runs short.

http://www.stgolabs.net/lat_ctx.png

