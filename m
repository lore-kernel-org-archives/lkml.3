Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbbAMKhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:37:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:48716 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbbAMKho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:37:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,749,1413270000"; 
   d="scan'208";a="669003367"
Date: Tue, 13 Jan 2015 12:37:21 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] driver core: property: support for generic property
Message-ID: <20150113103721.GB1856@kuha.fi.intel.com>
References: <1421061344-195095-1-git-send-email-heikki.krogerus@linux.intel.com>
 <3315410.c1hB71JUOk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3315410.c1hB71JUOk@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:35:09AM +0100, Rafael J. Wysocki wrote:
> > @@ -51,13 +175,6 @@ EXPORT_SYMBOL_GPL(fwnode_property_present);
> >  	(val) ? of_property_read_##type##_array((node), (propname), (val), (nval)) \
> >  	      : of_property_count_elems_of_size((node), (propname), sizeof(type))
> >  
> > -#define DEV_PROP_READ_ARRAY(_dev_, _propname_, _type_, _proptype_, _val_, _nval_) \
> > -	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
> > -		(OF_DEV_PROP_READ_ARRAY(_dev_->of_node, _propname_, _type_, \
> > -					_val_, _nval_)) : \
> > -		acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
> > -				   _proptype_, _val_, _nval_)
> > -
> 
> The macro was used here for a reason.  Can't you replace it with an extended
> macro instead?

OK, I'll change it.

Thanks,

-- 
heikki
