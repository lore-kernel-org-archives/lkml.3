Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaKDN1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:27:33 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36421 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaKDN11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:27:27 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Fix overflow bug in string property parsing
 functions
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <darren.hart@intel.com>, stable@vger.kernel.org
In-Reply-To: <4744029.MmARg0u2A0@vostro.rjw.lan>
References: <1415057904-6187-1-git-send-email-grant.likely@linaro.org>
	<4744029.MmARg0u2A0@vostro.rjw.lan>
Date: Tue, 04 Nov 2014 13:27:21 +0000
Message-Id: <20141104132721.3199FC408F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014 01:43:24 +0100
, "Rafael J. Wysocki" <rjw@rjwysocki.net>
 wrote:
> On Monday, November 03, 2014 11:38:24 PM Grant Likely wrote:
> 
> [cut]
> 
> > diff --git a/include/linux/of.h b/include/linux/of.h
> > index 6545e7aec7bb..3b3c6e849ae8 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -267,14 +267,12 @@ extern int of_property_read_u64(const struct device_node *np,
> >  extern int of_property_read_string(struct device_node *np,
> >  				   const char *propname,
> >  				   const char **out_string);
> > -extern int of_property_read_string_index(struct device_node *np,
> > -					 const char *propname,
> > -					 int index, const char **output);
> >  extern int of_property_match_string(struct device_node *np,
> >  				    const char *propname,
> >  				    const char *string);
> > -extern int of_property_count_strings(struct device_node *np,
> > -				     const char *propname);
> > +extern int of_property_read_string_helper(struct device_node *np,
> > +					      const char *propname,
> > +					      const char **out_strs, size_t sz, int index);
> >  extern int of_device_is_compatible(const struct device_node *device,
> >  				   const char *);
> >  extern int of_device_is_available(const struct device_node *device);
> > @@ -486,15 +484,9 @@ static inline int of_property_read_string(struct device_node *np,
> >  	return -ENOSYS;
> >  }
> >  
> > -static inline int of_property_read_string_index(struct device_node *np,
> > -						const char *propname, int index,
> > -						const char **out_string)
> > -{
> > -	return -ENOSYS;
> > -}
> > -
> > -static inline int of_property_count_strings(struct device_node *np,
> > -					    const char *propname)
> > +static inline int of_property_read_string_helper(struct device_node *np,
> > +						 const char *propname,
> > +						 char **out_strs, size_t sz, int index)
> 
> 	const char **out_strs, size_t sz, int index)
> 
> >  {
> >  	return -ENOSYS;
> >  }
> 
> Other than that, looks good to me.

Fixed, thanks.

g.

