Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaEZMX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:23:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51488 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751664AbaEZMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:23:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V7 08/11] ACPI: always register memory hotplug scan handler even if CONFIG_X86_INTEL_LPSS is cleared
Date: Mon, 26 May 2014 14:40:58 +0200
Message-ID: <2390763.sjfZLLMhWb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140526115235.GD1765@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <4177604.8JWRhYqtaS@vostro.rjw.lan> <20140526115235.GD1765@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 26, 2014 02:52:35 PM Mika Westerberg wrote:
> On Mon, May 26, 2014 at 01:53:39PM +0200, Rafael J. Wysocki wrote:
> > > I'm wondering whether it is worth the ugliness to get platform bus
> > > enumeration the default?
> > > 
> > > Since you already have the PNP whitelist, can't we just use that for PNP
> > > and keep these files as they are? In other words, don't make any kind of
> > > physical device by default and let the scan handlers to decide.
> > 
> > Well, that's tempting, but then we'd get one more whitelist pretty much without
> > any benefit, because we'd be still going to have the list in acpi_platform.c.
> > 
> > The purpose of the whole exercise is not to prevent PNP devices from being
> > created by default (which admittedly is a nice side effect), but to get rid
> > of the white list in acpi_platform.c - and in particular, to avoid the
> > necessity to add every ACPI-enumerated platform device to that list in the
> > future.
> 
> Yes, I understand but that list currently has only 5 entries. Are
> we expecting to have much more entries there in the future?

Yes, we are.  Pretty much anything that's DT-enumerable today may be
ACPI-enumerable in the future.  But you should know that. ;-)

> For LPSS devices we can't get rid of the list since we need to pass
> ->driver_data based on the _HID anyway.

Obviously.

Rafael

