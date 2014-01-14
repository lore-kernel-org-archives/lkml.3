Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaANMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:16:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50320 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaANMQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:16:54 -0500
Date: Tue, 14 Jan 2014 12:16:39 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Dave Young <dyoung@redhat.com>
Cc: wim@iguana.be, dzickus@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140114121639.77fe75ec@alan.etchedpixels.co.uk>
In-Reply-To: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 16:23:23 +0800
Dave Young <dyoung@redhat.com> wrote:

> In kdump kernel watchdog could interrupt vmcore capturing because we
> have no way to disable/stop it while crashing happens.

Lots of watchdogs cannot be stopped.

> Add a module parameter stop_before_register so watchdog can be stopped
> before register in driver loading path. Thus we can try to load the
> watchdog driver as early as possible in kdump kernel to ensure vmcore
> capturing.

If you want to kdump then don't start the watchdog. The goal of the
watchdog is to make sure the system never gets stuck. Adding conditions
and special cases simply increases the odds of something bad not
triggering the watchdog.

If you have a system that can stop the watchdog then providing no way out
is not set you can open it and stop it.

I don't see the need for any kernel change here

- if it can't be stopped you lost
- if "nowayout" is set then by design you lost
- if it can be stopped, you can open and stop it

Now whether in the !nowayout case the watchdog core should catch whatever
hooks/notifiers are available and stop any watchdogs it can on a
kexec/kdump is a more interesting question and probably needs to default
to not doing so but with the option to force otherwise for debugging work.

Alan
