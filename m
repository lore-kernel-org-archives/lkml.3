Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3AYUrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:47:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:55977 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab3AYUrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:47:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Rientjes <rientjes@google.com>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sysfs: Fix build when sysfs is disabled
Date: Fri, 25 Jan 2013 21:53:39 +0100
Message-ID: <1511313.IITM7eMxcu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130125204234.GA13245@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com> <20130125204234.GA13245@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 25, 2013 12:42:34 PM Greg Kroah-Hartman wrote:
> On Fri, Jan 25, 2013 at 12:13:59PM -0800, David Rientjes wrote:
> > "sysfs: Functions for adding/removing symlinks to/from attribute groups" 
> > causes a build failure when CONFIG_SYSFS is disabled:
> > 
> > drivers/acpi/power.c: In function 'acpi_power_hide_list':
> > drivers/acpi/power.c:463: error: implicit declaration of function 'sysfs_remove_link_from_group'
> > drivers/acpi/power.c: In function 'acpi_power_expose_list':
> > drivers/acpi/power.c:486: error: implicit declaration of function 'sysfs_add_link_to_group'
> > 
> > We need to define empty functions for this config to avoid ifdefs in the 
> > code.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  include/linux/sysfs.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Rafael has to take this through his tree.

Thanks for the patch and review.

I will fold it into the original patch to reduce bisection pain.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
