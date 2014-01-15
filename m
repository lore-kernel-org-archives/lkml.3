Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaAOMQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:16:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaAOMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:16:13 -0500
Date: Wed, 15 Jan 2014 12:15:56 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Dave Young <dyoung@redhat.com>
Cc: wim@iguana.be, dzickus@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140115121556.0407a099@alan.etchedpixels.co.uk>
In-Reply-To: <20140115005931.GB23767@dhcp-16-126.nay.redhat.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
	<20140114121639.77fe75ec@alan.etchedpixels.co.uk>
	<20140115005931.GB23767@dhcp-16-126.nay.redhat.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> watchdog and crash dump really conflicts to some degree, from the watchdog
> point of view it can reboot system whhen kdump kernel hangs. But from kdump
> point of view it want ensure saving the vmcore for later debugging.
> 
> Maybe we can only select only one in this case.

You want to be able to make a decision at runtime which to use.

> > - if it can be stopped, you can open and stop it
> 
> For the last one since crashing happens we have no chance to open and stop.

When you decide you need to set up to catch a core rather than just
crash you can open and stop the watchdog (if supported), and you can then
set up for a kdump and then at some point later if it crashes capture the
dump.

As you say the two are basically incompatible models of operating, but
that also means if you are about to take a dump you want ensure you will
not be disturbed. So as far as I can see if you might need to take a
dump, turn the watchdog off in advance. Worrying about it as you take a
dump is too late.

Alan
