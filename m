Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaG2Uvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:51:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58009 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751753AbaG2Uvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:51:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vinson Lee <vlee@twopensource.com>
Cc: William Dauchy <wdauchy@gmail.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
Date: Tue, 29 Jul 2014 23:10:19 +0200
Message-ID: <2026468.U7VDB8Dm9m@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAHTgTXV_kJ=bUOEQjbxM8+tZ+Df--xrZxH5bwkGFqffLd5h9LA@mail.gmail.com>
References: <5386F2C7.8080400@redhat.com> <CAJ75kXYJL4jD=81NYPYpji9grJQkzMKdgLhRMA=YFstHzzZ0=A@mail.gmail.com> <CAHTgTXV_kJ=bUOEQjbxM8+tZ+Df--xrZxH5bwkGFqffLd5h9LA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 29, 2014 11:13:55 AM Vinson Lee wrote:
> On Tue, Jul 29, 2014 at 2:53 AM, William Dauchy <wdauchy@gmail.com> wrote:
> > Hi Vinson,
> >
> > On Mon, Jul 28, 2014 at 9:11 PM, Vinson Lee <vlee@twopensource.com> wrote:
> >> The warning first happens with 3.14-rc1. The warning does not occur with 3.13.0.
> >
> > Hitting the same issue here with a similar trace on 3.14.x. Did you
> > start bisecting?
> >
> > Regards,
> > --
> > William
> 
> 
> I bisected the warning that I'm seeing to this commit.
> 
> commit 202317a573b20d77a9abb7c16a3fd5b40cef3d9d
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri Nov 22 21:54:37 2013 +0100
> 
>     ACPI / scan: Add acpi_device objects for all device nodes in the namespace

Interesting.

Does the appended patch make any difference?

Rafael

---
 drivers/pnp/pnpacpi/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -319,8 +319,7 @@ static int __init acpi_pnp_match(struct
 	struct pnp_dev *pnp = _pnp;
 
 	/* true means it matched */
-	return !acpi->physical_node_count
-	    && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
+	return pnp->data == acpi;
 }
 
 static struct acpi_device * __init acpi_pnp_find_companion(struct device *dev)

