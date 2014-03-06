Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaCFPoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:44:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42600 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752238AbaCFPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:44:53 -0500
Date: Thu, 6 Mar 2014 10:44:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jagdish Gedia <jvgediya@gmail.com>
cc: Peter Chen <Peter.Chen@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: USB remote wakeup through gpio interrupt
In-Reply-To: <CAOAoqGu4exeZP2wgEWpRyD7+4RVRbB=vOe4Hc+rK3CVVigCWvg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1403061043520.13996-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Jagdish Gedia wrote:

> Hi Alan,
> 
> As you have told, i have executed pm_request_resume() function from my
> interrupt handler, and it is waking up my USB device. I have
> implemented all this functionality in class driver(cdc-acm.c).
> but what is happening is after 2-3 times, ausosuspend is getting
> disable for my device. I want autosuspend to be enabled for usb device
> forever. Do pm_request_resume function causes this behavior?

No.  The various versions of pm_runtime_get will cause it, though, if 
they aren't balanced by some form of pm_runtime_put.

Alan Stern

