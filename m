Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaFTOsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:48:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46342 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751649AbaFTOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:48:10 -0400
Date: Fri, 20 Jun 2014 10:48:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Kevin Hilman <khilman@linaro.org>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <17793417.Syoi52bq6K@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406201043420.1160-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Rafael J. Wysocki wrote:

> > For a general device, the fact that dev->power.is_suspended is set
> > means the device _has_ been powered down.  Even though the
> > runtime_status may not have changed, the PM core has to assume the
> > device is not available for use.
> 
> This seems to go a bit too far.  What power.is_suspended actually means is
> that __device_suspend() has run for the device successfully.  What the
> implications of that are depends on the bus type (or subsystem in general)
> and device driver.
> 
> > While your I2C devices may be useable even after the ->suspend callback
> > returns, for most devices this isn't true.  So we shouldn't allow
> > rpm_resume() to return imediately when is_suspended is set.
> 
> I can agree with that.

We really do need to decide more precisely how runtime PM and system PM 
will interact.  Should ->runtime_resume callbacks be allowed after 
->suspend has returned?

Kevin has stated that some devices do need this ability.  But most
don't.  The PM core needs to handle these conflicting requirements
somehow.

Note: this is a separate issue from the meaning of disabled_depth > 0.

Alan Stern

