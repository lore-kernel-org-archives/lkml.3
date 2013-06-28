Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3F1Xej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:34:39 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41493 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3F1XeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <1771749.8rDXNf8giR@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan>
	<1515394.L46AJCfCTt@vostro.rjw.lan>
	<1771749.8rDXNf8giR@vostro.rjw.lan>
Date: Fri, 28 Jun 2013 16:34:21 -0700
X-Google-Sender-Auth: Pt4uJSm0f0BuRwB7Xx7XZhNmx6E
Message-ID: <CAE9FiQU8Zwm+8nrT4Sg9h7_P-YVNamg+udLjVaZ0PyNmm-t7bg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ACPI / dock: Rework the handling of notifications
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 3:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The ACPI dock driver uses register_acpi_bus_notifier() which
> installs a notifier triggered globally for all system notifications.
> That first of all is inefficient, because the dock driver is only
> interested in notifications associated with the devices it handles,
> but it has to handle all system notifies for all devices.  Moreover,
> it does that even if no docking stations are present in the system
> (CONFIG_ACPI_DOCK set is sufficient for that to happen).  Besides,
> that is inconvenient, because it requires the driver to do extra work
> for each notification to find the target dock station object.
>
> For these reasons, rework the dock driver to install a notify
> handler individually for each dock station in the system using
> acpi_install_notify_handler().  This allows the dock station
> object to be passed directly to the notify handler and makes it
> possible to simplify the dock driver quite a bit.  It also
> reduces the overhead related to the handling of all system
> notifies when CONFIG_ACPI_DOCK is set.

original change to use register_acpi_bus_notifier, have two assumption
1.  two dock_station will have same handle.
2. acpi subsystem: non root acpi device only can have one system
notifier installed.

Maybe you can rework acpi_install_notify_handler to fix 2.

Thanks

Yinghai
