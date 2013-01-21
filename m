Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3AUWfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:35:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48548 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab3AUWff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:35:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC][Update 2][PATCH 3/4] sysfs: Functions for adding/removing symlinks to/from attribute groups
Date: Mon, 21 Jan 2013 23:41:35 +0100
Message-ID: <6110949.dY5glp6Ioa@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130121205820.GC17006@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <7521411.VG2IjTvoWi@vostro.rjw.lan> <20130121205820.GC17006@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 21, 2013 12:58:20 PM Greg Kroah-Hartman wrote:
> On Mon, Jan 21, 2013 at 02:06:27PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The most convenient way to expose ACPI power resources lists of a
> > device is to put symbolic links to sysfs directories representing
> > those resources into special attribute groups in the device's sysfs
> > directory.  For this purpose, it is necessary to be able to add
> > symbolic links to attribute groups.
> > 
> > For this reason, add sysfs helper functions for adding/removing
> > symbolic links to/from attribute groups, sysfs_add_link_to_group()
> > and sysfs_remove_link_from_group(), respectively.
> 
> Those functions are fine, but why sysfs_add_link()?

Do you mean the helper?  I couldn't invent a better name. :-)

Would sysfs_create_link_sd() be better?

> It looks identical to sysfs_create_link(), why would you call one and not
> the other?

Because sysfs_create_link() takes a kobject as the first argument and I want
a sysfs_dirent.

> Why would anything outside of the sysfs core code ever have a pointer to a
> sysfs_dirent?

I don't see a reason and that sysfs_add_link() really is internal (it shouldn't
be exported then, yes).

I need to make a link from an attribute group under a kobject and not from the
kobject itself, that's all.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
