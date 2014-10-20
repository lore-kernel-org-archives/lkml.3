Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaJTOOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:14:54 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51254 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaJTOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:14:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware node properties
Date: Mon, 20 Oct 2014 16:14:35 +0200
Message-ID: <2472256.PcjMGW56U7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2095758.cxee3gtjhK@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1979177.qygBOVQh8h@wuerfel> <2095758.cxee3gtjhK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:c4ltRgeeoEd7OZrH3/lmLt/41XRvSh5oYwnWvzRcXc2
 c/dEx2ct09ZvXr7IRupycwdefuHpstI7Nqfh2O9+7dWvvR0G33
 Ziih0GhEnMpiU9qHi6Fli0ghjy1Y2YU2hHPGu5eWR+k/90vlhl
 8kPUyTUDEh41Frs+DVHSmfqmVF2ac9afiqzTqGC4vZcvtJYVj4
 a5BjmkIw4RkuhCUI8c8CsvA3i9698ROqdFDL+TlmIJiKzT+Txz
 2XexjEp3geAgu38TnChygiCHO1X8iQn0ExZW4TU3IElLUj8vxr
 KRN19tgdyLkkzJv3uxQkxUAdtq27/KyASLDrHM2i4oivGdRcB5
 eouDiUrCisR3QdqJJ4oQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 01:30:47 Rafael J. Wysocki wrote:
> On Saturday, October 18, 2014 11:35:21 AM Arnd Bergmann wrote:
> > On Friday 17 October 2014 14:14:53 Rafael J. Wysocki wrote:
> > > +/**
> > > + * fwnode_property_present - check if a property of a firmware node is present
> > > + * @fwnode: Firmware node whose property to check
> > > + * @propname: Name of the property
> > > + */
> > > +bool fwnode_property_present(struct fwnode_handle *fwnode, const char *propname)
> > > +{
> > > +       if (is_of_node(fwnode))
> > > +               return of_property_read_bool(of_node(fwnode), propname);
> > > +       else if (is_acpi_node(fwnode))
> > > +               return !acpi_dev_prop_get(acpi_node(fwnode), propname, NULL);
> > > +
> > > +       return false;
> > > +}
> > > +EXPORT_SYMBOL_GPL(fwnode_property_present);
> > > 
> > 
> > Should this be
> > 
> >               return acpi_dev_prop_get(acpi_node(fwnode), propname, NULL);
> > 
> > without the '!'?
> 
> No, acpi_dev_prop_get() returns 0 on success. 

Ah, got it now.

> > I'm also unsure about the '_present' vs '_read_bool' naming. IIRC we had
> > a long debate about this before we decided on 'read_bool' for DT, and
> > I don't really want to start a new debate, but being consistent would
> > be nice.
> > 
> > We could of course have
> > 
> > static inline bool fwnode_property_read_bool(struct fwnode_handle *fwnode, const char *propname)
> > {
> >       return fwnode_property_present(fwnode, propname);
> > }
> > 
> > which is completely redundant, but would help for drivers using the
> > interface to document whether we are checking for bool property that
> > we expect to be either empty or absent (_get_bool), vs checking for
> > the presence of a non-empty property (_present).
> 
> I'm fine with that, so I'll add fwnode_property_read_bool() (and an analogous
> wrapper for device_) to patches [02/12] and [09/12].
> 
> I'll be sending updates of them shortly, so please have a look at those.

Ok, will do.

	Arnd
