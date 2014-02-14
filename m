Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBNQNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:13:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaBNQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:13:07 -0500
Date: Fri, 14 Feb 2014 08:13:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214161302.GA16416@infradead.org>
References: <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:32:55PM -0800, Linus Torvalds wrote:
> We'd have to teach each user of "dequeue_signal()" to free the siginfo
> thing. Which shouldn't be too bad - I think we've collected all of
> that into generic code, and there isn't the mass or architecture code
> that knows about these things any more. But there are a few odd
> drivers etc and signalfd.

The few odd drivers are nbd, jffs2 and the usb mass storage gadget.
All of these have in common that they try to handle signals in a kernel
thread (which we don't even allow by default), and that they ignore the
siginfo.  I think they could mostly be replaced by an addition to the
kthread API to allow a kthread to be killed by signals for legacy
reasons.

