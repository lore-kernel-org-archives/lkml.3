Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaESXFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:05:49 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:31535 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaESXFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:05:47 -0400
Message-ID: <1400540222.18128.6.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI/hotplug: Fix STARTING/DYING action in
 acpi_cpu_soft_notify()
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 16:57:02 -0600
In-Reply-To: <2011129.WMiXDPUasW@vostro.rjw.lan>
References: <1399557539-7282-1-git-send-email-toshi.kani@hp.com>
	 <2011129.WMiXDPUasW@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 00:55 +0200, Rafael J. Wysocki wrote:
> On Thursday, May 08, 2014 07:58:59 AM Toshi Kani wrote:
> > During CPU online/offline testing on a large system, one of the
> > processors got stuck after the message "bad: scheduling from the
> > idle thread!".  The problem is that acpi_cpu_soft_notify() calls
> > acpi_bus_get_device() for all action types.  CPU_STARTING and
> > CPU_DYING do not allow the notify handlers to sleep.  However,
> > acpi_bus_get_device() can sleep in acpi_ut_acquire_mutex().
> > 
> > Change acpi_cpu_soft_notify() to return immediately for CPU_STARTING
> > and CPU_DYING as they have no action in this handler.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> 
> Queued up for 3.16, thanks!

Great! Thanks Rafael!
-Toshi

