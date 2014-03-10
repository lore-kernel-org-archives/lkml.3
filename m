Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaCJScb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:32:31 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59690 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbaCJSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:32:28 -0400
Message-ID: <1394476346.12752.43.camel@x220>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: Paul Bolle <pebolle@tiscali.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 19:32:26 +0100
In-Reply-To: <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>
	 <1394447253.2979.12.camel@x220>
	 <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de>
	 <1394465314.12752.18.camel@x220>
	 <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 18:32:27.0356 (UTC) FILETIME=[169001C0:01CF3C8F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Jerome, who submitted a patch similar to mine.]

On Mon, 2014-03-10 at 18:04 +0100, Thomas Gleixner wrote:
> On Mon, 10 Mar 2014, Paul Bolle wrote:
> > https://lkml.org/lkml/2012/9/24/221 . Is that analysis incorrect?
> 
> Kinda. But there is no reason for the fast calibration to fail except
> BIOS induced SMI nonsense.

What made me submit my patch, in 2012, is that this error is printed
very early, before boot animation kicks in. Ie, it looks rather scary.
And when I dug through the code I noticed that this condition seems
actually to be handled already: the kernel just tries an alternative
calibration method.

So I think this should be printed at (say) KERN_INFO level (so it will
be suppressed during boot). More so if the solution would be "upgrade
the BIOS". Upgrading the BIOS on a ThinkPad, for instance, can require
fiddling with quite a bit of low level programs. And how do we know an
upgraded BIOS actually helps?

Or is there a way to handle the "SMI nonsense" (whatever that may be)?


Paul Bolle

