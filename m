Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbbAHWFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:05:36 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50079 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbAHWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:05:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] serial: 8250: Make ISA ports optional
Date: Thu, 08 Jan 2015 23:05:12 +0100
Message-ID: <1896224.oMI8M6J5T7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54AEAC47.1040403@hurleysoftware.com>
References: <1420513785-23660-1-git-send-email-peter@hurleysoftware.com> <20150108131008.16c9a31c@lxorguk.ukuu.org.uk> <54AEAC47.1040403@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zYqUSBrBS6uCLv29FQcr5J6Q/SP3kTaoAZ2H2kFawLhQ9DfliTg
 Jk3aY5KxHdOMq+ZhqfPcn0GHNhXY1cbrhaXVEy33uB3YngLEBKgeQlnElwJ/lXUWrrDjEwn
 dW1dqai3z/0MKX4fz54sZ+gVhzXq4C4BW5YDsluXYau8sEBpLHSq5FZKutxAGrYmsFzyboA
 hWbpsIjmc1/qrSu0FNQLQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 11:11:51 Peter Hurley wrote:
> 
> This interface is just storage and minor allocation, since the
> port-reuse behavior will be limited to the "universal" driver.
> From a sub-driver perspective, the shared storage is actually
> a hindrance, so that reduces the requirement to minor allocation.
> 
> And that's where I'm stuck at the moment -- how to share ttyS
> minor allocation. ttyS console is a related problem.

One idea that has come up in the past but never saw an implementation
is to make the ttyS namespace and minor numbers completely generic and
let any serial port driver use it. This would be a major rework, but
have the added advantage of cleaning up a number of other namespace
issues as well. There also lots of open question, in particular how
to maintain compatibility with existing drivers. One could imagine
that each uart always gets a ttyS device and optionally also gets
a device node for the same port with a driver specific chardev as
most of them do today. Or it could be an either/or decision that is
made at compile time or as a module parameter.

	Arnd
