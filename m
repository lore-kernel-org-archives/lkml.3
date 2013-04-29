Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3D2Plw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:41:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47141 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756809Ab3D2Plv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:41:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/nDzMa8WH2K74QAZXL6r9x
Date: Mon, 29 Apr 2013 08:41:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Jackson <mpfj-list@newflow.co.uk>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        tglx@linutronix.de, lkml <linux-kernel@vger.kernel.org>
Subject: Re: v3.9.0-rc8 : oops in tick_do_update_jiffies64+0xbc/0x110
Message-ID: <20130429154146.GB28721@atomide.com>
References: <517E3039.2070204@newflow.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517E3039.2070204@newflow.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Jackson <mpfj-list@newflow.co.uk> [130429 01:38]:
> I've been experiencing several crashes all pointing exactly the same place in the same tick routine (see below).
> 
> The "exception stack" trace at the end changes depending on when the oops occurs.
> 
> I've had the oops occur maybe 6 times in the last 50 reboots.
> 
> Any ideas ?

Sounds like it might be an issue with the physical memory or
the timings. It could also be related to the idle loop not
restoring something right for deeper idle states that corrupts
the memory. And that's why it would seem to appear while waking
to a timer.

Maybe disable PM and run memtester to see if that runs reliably?

Regards,

Tony
