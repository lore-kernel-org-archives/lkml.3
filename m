Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaFVNWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 09:22:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53321 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751084AbaFVNWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 09:22:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
Date: Sun, 22 Jun 2014 15:40:17 +0200
Message-ID: <1645345.yNjrKp8T0k@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7h4mzftgdl.fsf@paris.lan>
References: <Pine.LNX.4.44L0.1406201043420.1160-100000@iolanthe.rowland.org> <7h4mzftgdl.fsf@paris.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 20, 2014 02:34:14 PM Kevin Hilman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Fri, 20 Jun 2014, Rafael J. Wysocki wrote:
> >
> >> > For a general device, the fact that dev->power.is_suspended is set
> >> > means the device _has_ been powered down.  Even though the
> >> > runtime_status may not have changed, the PM core has to assume the
> >> > device is not available for use.
> >> 
> >> This seems to go a bit too far.  What power.is_suspended actually means is
> >> that __device_suspend() has run for the device successfully.  What the
> >> implications of that are depends on the bus type (or subsystem in general)
> >> and device driver.
> >> 
> >> > While your I2C devices may be useable even after the ->suspend callback
> >> > returns, for most devices this isn't true.  So we shouldn't allow
> >> > rpm_resume() to return imediately when is_suspended is set.
> >> 
> >> I can agree with that.
> >
> > We really do need to decide more precisely how runtime PM and system PM 
> > will interact.  
> 
> Yes!
> 
> > Should ->runtime_resume callbacks be allowed after ->suspend has
> > returned?
> 
> Abolutely.
> 
> > Kevin has stated that some devices do need this ability.  But most
> > don't.  
> 
> Does it matter if most don't?  As long a some do, we need to support
> this.  It may not be "most" devices, but on the (mostly embedded) SoCs I
> work on, the devices that do need this tend to be rather crucial core
> devices that are used during the PM of other devices (e.g. I2C, SPI,
> GPIOs, etc. etc.)
> 
> > The PM core needs to handle these conflicting requirements
> > somehow.
> 
> I agree.  We've gone back and forth a few times on the various
> interactions between system PM and runtime PM over the years but it
> seems there are still things to clarify.

Well, we only considered a specific use case every time without looking at
the big picture, mostly because we didn't really know what the big picture
was.  I guess today we have enough experience to try to address all of these
problems together.

I guess we need to start with making a list of different types of bus type/driver
behavior existing today and how the core is supposed to interact with them.

Rafael

