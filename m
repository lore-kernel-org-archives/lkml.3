Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaKEUny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:43:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63596 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751310AbaKEUnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:43:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Timur Tabi <timur@codeaurora.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Wed, 05 Nov 2014 22:04:38 +0100
Message-ID: <2470178.4zbWKgRd7I@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54595ED7.2090406@codeaurora.org>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <545959A8.7010305@codeaurora.org> <54595ED7.2090406@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 05:18:47 PM Timur Tabi wrote:
> On 11/04/2014 04:56 PM, Timur Tabi wrote:
> >
> >  >  I'm
> >> not sure how much of that code can be shared between DT and ACPI ATM, but
> >> it looks like at least some of it can be shared.
> >
> > So ACPI does not support the concept if variable length properties?
> 
> Ah, I see that it does:
> 
> int acpi_dev_prop_read_array(struct acpi_device *adev, const char *propname,
> 			     enum dev_prop_type proptype, void *val,
> 			     size_t nval)
> {
> ...
> 	if (!val)
> 		return obj->package.count;
> 
> 
> If I pass NULL for 'val', it returns the number of items.

Yes, it does that.

If you pass NULL for val to device_property_read_*_array(), it will also
return the number of items in the property.  Including the string one.

We're missing a couple of calls that you'd need for pinctrl, but I'd rather
add those along with some users.

Rafael

