Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaK1J7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:59:39 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41675 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaK1J7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:59:37 -0500
Date: Fri, 28 Nov 2014 01:59:28 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, ntrrgc@gmail.com,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / video: check _DOD list when creating backlight
 device
Message-ID: <20141128095928.GA5106@norris-Latitude-E6410>
References: <542A4949.2020208@intel.com>
 <1648939.GaN1bonAuX@vostro.rjw.lan>
 <5436470B.3030306@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5436470B.3030306@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:27:55PM +0800, Aaron Lu wrote:
> On 10/01/2014 04:18 AM, Rafael J. Wysocki wrote:
> > On Tuesday, September 30, 2014 02:10:17 PM Aaron Lu wrote:
> >> The _DOD method lists which video output device is currently attached so
> >> we should only care about them and ignore others. An user recently
> >> reported that there are two acpi_video interfaces appeared on his system
> >> and one of them doesn't work. From the acpidump, it is found that there
> >> are more than one video output devices that have _BCM control method but
> >> the _DOD lists only one of them. So this patch checks if the video output
> >> device is in the _DOD list and will not create backlight device if it is
> >> not in the list. Also, we consider the broken _DOD case(reflected by the
> >> video->attached_count is 0) and do not change behaviour for those broken
> >> _DOD systems.
> >>
> >> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=84111
> >> Reported-and-tested-by: ntrrgc@gmail.com
> >> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > 
> > This looks reasonable to me, but I'm a little afraid that it may break
> > systems which forget to list valid interfaces in the _DOD.
> 
> Indeed, this is possible.

And indeed, there is a regression! My Dell Latituded E6410's backlight
control no longer works after this commit, and I get messages like this
instead:

[   57.214610] ACPI: Failed to switch the brightness

If I revert this commit, my backlight controls work again. Also, I
regain a cooling device (?) that was being ignored:

[    1.332682] acpi device:02: registered as cooling_device0

Do you need any additional info to handle the regression, or should we
just revert the patch?

Brian
