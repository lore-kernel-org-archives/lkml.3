Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344Ab3E2XjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab3E2Xix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:38:53 -0400
Date: Wed, 29 May 2013 16:38:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
Message-Id: <20130529163813.5f637f04.akpm@linux-foundation.org>
In-Reply-To: <1369869467.22004.122.camel@joe-AO722>
References: <519BC066.5080600@acm.org>
	<20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
	<1369869467.22004.122.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 16:17:47 -0700 Joe Perches <joe@perches.com> wrote:

> >   We could perhaps have a checkpatch rule
> > which looks for comparisons against jiffes (and any other
> > time-measuring variables we can detect)
> 
> other variables like?

Grepping for time_after finds a bunch.  There's no real pattern to it though.
