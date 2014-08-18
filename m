Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbaHRE2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 00:28:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58758 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750709AbaHRE17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 00:27:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/9] Driver core: Unified device properties interface for platform firmware
Date: Mon, 18 Aug 2014 06:46:42 +0200
Message-ID: <2012139.h82pgQUHg7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140817124913.A597FC40F4B@trevor.secretlab.ca>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com> <1408255459-17625-4-git-send-email-mika.westerberg@linux.intel.com> <20140817124913.A597FC40F4B@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 17, 2014 01:49:13 PM Grant Likely wrote:
> 
> Hi Mika and Rafael,
> 
> Comments below...

[cut]

> > +enum dev_prop_type {
> > +	DEV_PROP_U8,
> > +	DEV_PROP_U16,
> > +	DEV_PROP_U32,
> > +	DEV_PROP_U64,
> > +	DEV_PROP_STRING,
> > +	DEV_PROP_MAX,
> > +};
> > +
> > +struct dev_prop_ops {
> > +	int (*get)(struct device *dev, const char *propname, void **valptr);
> > +	int (*read)(struct device *dev, const char *propname,
> > +		    enum dev_prop_type proptype, void *val);
> > +	int (*read_array)(struct device *dev, const char *propname,
> > +			  enum dev_prop_type proptype, void *val, size_t nval);
> 
> The associated DT functions that implement property reads
> (of_property_read_*) were created in part to provide some type safety
> when reading properties. This proposed API throws that away by accepting
> a void* for the data field, which I don't want to do. This API either
> needs to have a separate accessor for each data type, or it needs some
> other mechanism (accessor macros?) to ensure the right type is passed
> in.

The intention is to add static inline functions like:

int device_property_read_u64(struct device *dev, const char *propname, u64 *val)
{
	return device_property_read(dev, propname, DEV_PROP_U64, val);
}

and so on for the other property types.  They just have not been implemented in
this version of the patch.

> 
> > +	int (*child_count)(struct device *dev);
> > +};
> > +
> > +#ifdef CONFIG_ACPI
> > +extern struct dev_prop_ops acpi_property_ops;
> > +#endif
> 
> Rendered moot by my comment about eliminating the ops structure, but the
> above shouldn't appear here. acpi_property_ops shouldn't ever be visible
> outside ACPI core code, so it shouldn't be in this header.

It doesn't look like this has to be present here.  At least this particular
patch should compile just fine after removing the 3 lines above.

That seems to be a leftover from one of the previous versions of it.

Rafael

