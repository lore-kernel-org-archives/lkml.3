Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab3CICTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:19:46 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49933 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760118Ab3CICTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:19:45 -0500
Date: Fri, 8 Mar 2013 21:19:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Hurley <peter@hurleysoftware.com>
cc: Shawn Starr <shawn.starr@rogers.com>, Thomas Meyer <thomas@m3y3r.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <1362778382.20990.17.camel@thor.lan>
Message-ID: <Pine.LNX.4.44L0.1303082116310.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Peter Hurley wrote:

> [ +linux-usb ]
> 
> On Fri, 2013-03-08 at 14:12 -0500, Shawn Starr wrote:
> > Hello folks,
> > 
> > I am noticing since rc0 and now rc1, very poor interrupt handling. Keyboard response, mouse movements, display refreshing etc. General input/display sluggishness. Did something break IRQ handling somewhere? I need to validate if this happens with X not running also if it is i915 related somehow. The behavor is noticed in a console login however.
> > 
> > Device: Lenovo W500 laptop
> 
> Hi Shawn,
> 
> Unhandled interrupts is the problem.
> 
> Is the device below being id'd properly?
> If you remove this device, does the problem go away?

Does either of the kernels in question have commit 0f815a0a700b (USB:
UHCI: fix IRQ race during initialization)?  That commit was added to
fix precisely this sort of thing.

Alan Stern

