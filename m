Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3BFQQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:16:00 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34429 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756482Ab3BFQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:15:59 -0500
Message-ID: <1360167343.3298.56.camel@thor.lan>
Subject: Re: 3.8-rc regression with pps-ldisc due to 70ece7a731
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, giometti@linux.it,
        lasaine@lvk.cs.msu.su, linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 11:15:43 -0500
In-Reply-To: <20130204070805.28980.qmail@science.horizon.com>
References: <20130204070805.28980.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 02:08 -0500, George Spelvin wrote:
> Just a quick update: the previously posted patch *does* work;
> the crash I was experiencing was pilot error.
> 
> My NTP server is running a 3.8.0-rc6-dirty kernel right now.
> 
> I'll research whether that race I talk about in pps_tty_dcd_change
> is actually possible or not (can interrupts start arriving before the
> ->open() method returns?) and work out a finished minimal bugfix patch
> if nobody else finds a better solution.

You are not supposed to receive ldisc->dcd_change() calls outside
the open()/close() pair.

The ldisc is separately enabled/halted which is supposed to prevent
ldisc usage if a ldisc reference cannot be acquired (because it's
halted). The reference is acquired prior to calling the ->dcd_change()
routine.

In the patch series I sent, I changed the BUG_ON() to WARN_ON_ONCE().
Please reply to that patch with the snipped kernel log output if it
warns in your testing and we'll go from there.

> (Have I mentioned how ANNOYING it is when the kernel dumps more than
> 50 lines of crash message to the console screen and then locks
> the keyboard so I can't scroll back?)

netconsole on 2nd machine (see Documentation/networking/netconsole.txt)

Regards,
Peter Hurley

