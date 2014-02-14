Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaBNQT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:19:26 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaBNQTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:19:25 -0500
Date: Fri, 14 Feb 2014 08:19:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214161912.GB20909@infradead.org>
References: <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140214161302.GA16416@infradead.org>
 <20140214161623.GU18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214161623.GU18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:16:24PM +0000, Al Viro wrote:
> > All of these have in common that they try to handle signals in a kernel
> > thread (which we don't even allow by default), and that they ignore the
> > siginfo.  I think they could mostly be replaced by an addition to the
> > kthread API to allow a kthread to be killed by signals for legacy
> > reasons.
> 
> FWIW, there's a funny situation - all users of dequeue_signal_lock()
> actually ignore info completely.  I'm not saying that we ought to
> stop returning it, but e.g. jbd part of that patch is simply

Might aswell stick the discmiss into what was dequeue_signal_lock().
Which at that point should get a saner name (maybe thread_dequeue_signal ?)
and lose all argument except maybe task_struct - not that it's
nessecary, but it would mirror the other functions usually used around
it.

