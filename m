Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaH2UQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:16:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaH2UQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:16:05 -0400
Date: Fri, 29 Aug 2014 13:16:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
Message-Id: <20140829131602.72c422ebd2fd3fba426379e8@linux-foundation.org>
In-Reply-To: <20140829195328.511550688@asylum.americas.sgi.com>
References: <20140829195328.511550688@asylum.americas.sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 14:53:28 -0500 Mike Travis <travis@sgi.com> wrote:

> 
> We have a large university system in the UK that is experiencing
> very long delays modprobing the driver for a specific I/O device.
> The delay is from 8-10 minutes per device and there are 31 devices
> in the system.  This 4 to 5 hour delay in starting up those I/O
> devices is very much a burden on the customer.
> 
> There are two causes for requiring a restart/reload of the drivers.
> First is periodic preventive maintenance (PM) and the second is if
> any of the devices experience a fatal error.  Both of these trigger
> this excessively long delay in bringing the system back up to full
> capability.
> 
> The problem was tracked down to a very slow IOREMAP operation and
> the excessively long ioresource lookup to insure that the user is
> not attempting to ioremap RAM.  These patches provide a speed up
> to that function.
> 

Really would prefer to have some quantitative testing results in here,
as that is the entire point of the patchset.  And it leaves the reader
wondering "how much of this severe problem remains?".

Also, the -stable backport is a big ask, isn't it?  It's arguably
notabug and the affected number of machines is small.

