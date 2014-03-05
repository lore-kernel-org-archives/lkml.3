Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaCEFpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:45:13 -0500
Received: from mail1.bemta12.messagelabs.com ([216.82.251.1]:33602 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbaCEFpL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:45:11 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 00:45:10 EST
X-Env-Sender: Jonathan.Ringle@gridpoint.com
X-Msg-Ref: server-15.tower-28.messagelabs.com!1393997882!28555206!1
X-Originating-IP: [67.200.113.45]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Date: Wed, 5 Mar 2014 00:37:56 -0500
From: Jon Ringle <jringle@gridpoint.com>
X-X-Sender: jringle@jringle-ubuntu
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Ringle, Jonathan" <Jonathan.Ringle@gridpoint.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add option to build with -O3
In-Reply-To: <20140305050927.GA8534@kroah.com>
Message-ID: <alpine.DEB.2.02.1403050019300.22601@jringle-ubuntu>
References: <1393977709-9809-1-git-send-email-jringle@gridpoint.com> <20140305050927.GA8534@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-EMS-Proccessed: KgU7Zc8frcTgvrN/cX2wdQ==
X-EMS-STAMP: mn1pWNY8IY2FozN6q0GKlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Mar 2014, Greg KH wrote:

> On Tue, Mar 04, 2014 at 07:01:49PM -0500, Jon Ringle wrote:
> > +config CC_OPTIMIZE_FOR_SPEED
> > +    bool "Optimze for speed (-O3)"
> > +    help
> > +      Enabling this option will pass "-O3" to gcc
> > +      resulting in a larger kernel (but possibly faster)
>
> Are you sure about that?  Have you measured it?

I do know that there is an improvement performance-wise for my particular
use-case.

My target is an ARM board being built with gcc-4.8.2. My board has on it a
sc16is740 that is used as an RS-485 port. The sc16is740 is on the i2c bus,
so when an interrupt comes in to indicate that there is data available to
be read, I need to get the data over the i2c bus. I do this on a kthread
to do this work. The i2c transactions (using i2c-davinci driver) are also
interrupt driven. I was seeing a lot of lost packets when receiving data
at only 19200. Adding the -O3 compile option helped in this regard in that
I am now rarely seeing packet loss.

Jon

The information contained in this transmission may contain confidential information.  If the reader of this message is not the intended recipient, you are hereby notified that any review, dissemination, distribution or duplication of this communication is strictly prohibited.  If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.
