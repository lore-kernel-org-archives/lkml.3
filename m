Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3AYUml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:42:41 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48824 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3AYUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:42:37 -0500
Date: Fri, 25 Jan 2013 12:42:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sysfs: Fix build when sysfs is disabled
Message-ID: <20130125204234.GA13245@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <1551140.kO91IOVbjI@vostro.rjw.lan>
 <1511541.AH8DLsNQJH@vostro.rjw.lan>
 <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301251211410.3815@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:13:59PM -0800, David Rientjes wrote:
> "sysfs: Functions for adding/removing symlinks to/from attribute groups" 
> causes a build failure when CONFIG_SYSFS is disabled:
> 
> drivers/acpi/power.c: In function 'acpi_power_hide_list':
> drivers/acpi/power.c:463: error: implicit declaration of function 'sysfs_remove_link_from_group'
> drivers/acpi/power.c: In function 'acpi_power_expose_list':
> drivers/acpi/power.c:486: error: implicit declaration of function 'sysfs_add_link_to_group'
> 
> We need to define empty functions for this config to avoid ifdefs in the 
> code.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/sysfs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Rafael has to take this through his tree.

