Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3JDQoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:44:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:55142 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:44:22 -0400
Message-ID: <524EF05E.4070402@linutronix.de>
Date: Fri, 04 Oct 2013 18:44:14 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: IRQ affinity notifiers vs RT
References: <1374708683.1732.38.camel@bwh-desktop.uk.level5networks.com>  <1377898155.4629.11.camel@bwh-desktop.uk.level5networks.com>  <52403B0B.1060305@linutronix.de> <1380584663.2562.27.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1380584663.2562.27.camel@bwh-desktop.uk.level5networks.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 01:44 AM, Ben Hutchings wrote:
> Right, but it looks quite strange to have this thread just for a
> (probably) quite rare event.  Maybe some day someone will work out how
> to make Octeon's IRQ management less unusual and then you can use the
> simpler approach for RT...

We have three threads for some rare events by now if I count correctly.
That is
- mce check on x86 (mce_notify_helper_thread)
- this one
- clock_was_set_delayed() (pending)

So right now I am thinking about a workqueue for rare events because if
I keep doing this we end up with a bunch useless tasks for something
that might never occur.

> Ben.

Sebastian
