Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaAGQK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:10:27 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46300 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaAGQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:10:19 -0500
Date: Tue, 7 Jan 2014 08:10:18 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
Message-ID: <20140107161018.GB24018@roeck-us.net>
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au>
 <52CB0948.6030702@infradead.org>
 <20140106203209.GA21630@roeck-us.net>
 <52CB53DC.4030901@infradead.org>
 <52CB65DA.2010103@roeck-us.net>
 <20140107130401.23bffcd2@endymion.delvare>
 <52CBF1CF.2000603@ti.com>
 <744357E9AAD1214791ACBA4B0B909263011BC64C@SHSMSX101.ccr.corp.intel.com>
 <52CC15F0.6020209@ti.com>
 <20140107160738.4a76a6d0@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107160738.4a76a6d0@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:07:38PM +0100, Jean Delvare wrote:
> On Tue, 7 Jan 2014 10:57:52 -0400, Eduardo Valentin wrote:
> > On 07-01-2014 10:05, Zhang, Rui wrote:
> > > BTW, I've been thinking of make CONFIG_THERMAL a bool since long time ago, the only thing that blocks me is that Thermal subsystem needs to register a hwmon device for each thermal zone and CONFIG_HWMON is a tristate.
> > 
> > I agree with the move of having CONFIG_THERMAL as bool. Unless you have
> > use cases where users are dynamically loading and unloading thermal per
> > user demand, which I doubt.
> 
> Modularity is not only about reloading modules (although this can be
> useful for developers in particular.) It's also about enabling many
> features in a generic distribution kernel and each feature only gets
> loaded/used on the hardware which needs it. This is why, as a
> distribution kernel maintainer, I keep complaining when I see boolean
> options which might easily be tristates.
> 
Agreed. Problem is really that it is not easy to declare cross-module
dependencies (eg THERMAL=m -> HWMON=m and THERMAL=y -> HWMON=y and
vice versa) in Kconfig. Declaring everything as bool can not be
the solution to that.

Guenter
