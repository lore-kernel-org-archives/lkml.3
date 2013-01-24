Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3AXM2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:28:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53285 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3AXM23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:28:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH 0/5] ACPI / PM: Export power information to user space
Date: Thu, 24 Jan 2013 13:34:31 +0100
Message-ID: <2285025.HJbzHTbVLh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130124003440.GD10969@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <1551140.kO91IOVbjI@vostro.rjw.lan> <20130124003440.GD10969@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 23, 2013 04:34:40 PM Greg Kroah-Hartman wrote:
> On Wed, Jan 23, 2013 at 06:56:43PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, January 22, 2013 03:15:52 AM Rafael J. Wysocki wrote:
> > > On Monday, January 21, 2013 02:03:03 PM Rafael J. Wysocki wrote:
> > > > On Monday, January 21, 2013 01:48:55 AM Rafael J. Wysocki wrote:
> > > > > On Sunday, January 20, 2013 03:51:40 PM Rafael J. Wysocki wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > The following patch series is about exporting ACPI power resources to user
> > > > > > space that will be necessary for PM diagnostics on new platforms (powertop is
> > > > > > the target).  Still, existing systems can also benefit from that, like my
> > > > > > oldish HP nx6325 on which the patches have been tested.
> > > > > > 
> > > > > > Patch [1/3] shouldn't be really controverisal, as it only makes it possible
> > > > > > to read power resources' reference counters from user space in a quite
> > > > > > straightforward way.
> > > > > > 
> > > > > > Patch [3/3], however, exposes lists of power resources associated with
> > > > > > different power states of devices using ACPI PM as sysfs subdirectories
> > > > > > containing symbolic links and that requires some sysfs changes made by
> > > > > > patch [2/3].
> > > > > > 
> > > > > > Admittedly, my sysfs skills are limited so please let me know if those
> > > > > > changes make sense and are acceptable from your perspective.  If not, then
> > > > > > please kindly advise what I can do instead of them.
> > > > > > 
> > > > > > The patches apply on top of the current linux-next branch of the linux-pm.git
> > > > > > tree.
> > > > > 
> > > > > Refreshed with Documentation/ABI files as requested.
> > > > 
> > > > Well, that version wasn't really a good one, due to mistakes in the docs
> > > > mostly, so a new one follows (with better docs hopefully).
> > > > 
> > > > Besides, I thought I'd include a patch that exposes ACPI power state
> > > > information, because it kind of belongs to the lot.  It goes as the new [1/4].
> > > > 
> > > > [2/4] is the previous [1/3] and so on.
> > > 
> > > Here it goes again after the changes we discussed earlier today.
> > > 
> > > I think I've addressed all of the comments, but if I overlooked something,
> > > please let me know.
> > 
> > So, the following is an update containing a patch ([1/5]) that fixes the
> > "creation of sysfs files after the device have been registered" problem.
> > Hopefully. :-)
> > 
> > Patches [2-3/5] are the previous [1-2/4] and they are almost identical as
> > before, so I added the ACKs you gave for them.  Patch [4/5] is the sysfs one
> > with the internal function placed in the internal header.  Patch [5/5] is
> > a rework of the one exposing the lists of power resources as directories
> > containing symbolic links.
> > 
> > Please let me know if you are fine with this.
> 
> These all look great, thanks for fixing up the acpi device notification
> mess, and the sysfs header file locations.  Feel free to take all of
> these through your tree.

I will, thanks a lot for reviewing!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
