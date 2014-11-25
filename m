Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaLBHzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:55:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55792 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaLBHzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:55:53 -0500
Date: Tue, 25 Nov 2014 15:05:28 -0800
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Message-ID: <20141125230527.GC32102@vmdeb7>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 04:09:18PM +0100, Pali Rohár wrote:
> This patch series add new acpi Dell Airplane Mode Switch driver (DELLABCE and
> DELRBTN acpi devices). It provides radio HW switch events (together with current
> state of radio devices) and export them via rfkill interface. These events are
> also used in dell-laptop driver instead i8042 filter hook function (when acpi
> device is available).
> 
> Pali Rohár (3):
>   platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
>   platform: x86: dell-rbtn: Export notifier for other kernel modules
>   platform: x86: dell-laptop: Use dell-rbtn instead i8042 filter when
>     possible
> 
>  drivers/platform/x86/Kconfig       |   14 ++
>  drivers/platform/x86/Makefile      |    1 +
>  drivers/platform/x86/dell-laptop.c |   67 +++++++++-
>  drivers/platform/x86/dell-rbtn.c   |  260 ++++++++++++++++++++++++++++++++++++
>  drivers/platform/x86/dell-rbtn.h   |   35 +++++
>  5 files changed, 372 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/platform/x86/dell-rbtn.c
>  create mode 100644 drivers/platform/x86/dell-rbtn.h

Alex, it is my understanding that this solution from Pali is a more complete
solution to dealing with the variety of dell wireless buttons and rfkill
mechanisms in the world today.

I currently have:
7c4d961 dell-wireless: new driver for dell wireless button for Windows 8
queued in for-next. If I have read your responses on this correctly, are we all
in agreement that I should drop the above patch, and apply these?

-- 
Darren Hart
Intel Open Source Technology Center
