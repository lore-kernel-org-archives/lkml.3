Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbaDIFv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:51:29 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:50701 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaDIFv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:51:26 -0400
Message-ID: <1397022682.4928.30.camel@marge.simpson.net>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Stancek <jstancek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>
Date: Wed, 09 Apr 2014 07:51:22 +0200
In-Reply-To: <20140409054139.GU10526@twins.programming.kicks-ass.net>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	 <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
	 <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
	 <20140408181305.GT10526@twins.programming.kicks-ass.net>
	 <CA+55aFz+yMdXfsb-t3JzDhj6=M=-ggjDDGAQSbtfEcNhgyoopA@mail.gmail.com>
	 <1860555101.1890107.1396990941681.JavaMail.zimbra@redhat.com>
	 <CA+55aFzYwNde4ZyKgy_raRx9nz4+8he1-Fk9+_DDhWs-7fBbjw@mail.gmail.com>
	 <20140409054139.GU10526@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 07:41 +0200, Peter Zijlstra wrote: 
> On Tue, Apr 08, 2014 at 03:30:07PM -0700, Linus Torvalds wrote:
> > So I'll have to leave this decision to the futex people. But the
> > attached slightly more complex patch *may* be the better one.
> 
> Of course, tglx is the main futex 'people' and he's not on CC.. *sigh*.

(Darren is a futex people _and_ a futextest people)

