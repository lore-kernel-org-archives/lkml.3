Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaEZM7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:59:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:16434 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaEZM7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:59:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="scan'208";a="436937989"
Date: Mon, 26 May 2014 15:58:59 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V7 08/11] ACPI: always register memory hotplug scan
 handler even if CONFIG_X86_INTEL_LPSS is cleared
Message-ID: <20140526125859.GG1765@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
 <4177604.8JWRhYqtaS@vostro.rjw.lan>
 <20140526115235.GD1765@lahna.fi.intel.com>
 <2390763.sjfZLLMhWb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2390763.sjfZLLMhWb@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 02:40:58PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 26, 2014 02:52:35 PM Mika Westerberg wrote:
> > On Mon, May 26, 2014 at 01:53:39PM +0200, Rafael J. Wysocki wrote:
> > > > I'm wondering whether it is worth the ugliness to get platform bus
> > > > enumeration the default?
> > > > 
> > > > Since you already have the PNP whitelist, can't we just use that for PNP
> > > > and keep these files as they are? In other words, don't make any kind of
> > > > physical device by default and let the scan handlers to decide.
> > > 
> > > Well, that's tempting, but then we'd get one more whitelist pretty much without
> > > any benefit, because we'd be still going to have the list in acpi_platform.c.
> > > 
> > > The purpose of the whole exercise is not to prevent PNP devices from being
> > > created by default (which admittedly is a nice side effect), but to get rid
> > > of the white list in acpi_platform.c - and in particular, to avoid the
> > > necessity to add every ACPI-enumerated platform device to that list in the
> > > future.
> > 
> > Yes, I understand but that list currently has only 5 entries. Are
> > we expecting to have much more entries there in the future?
> 
> Yes, we are.  Pretty much anything that's DT-enumerable today may be
> ACPI-enumerable in the future.  But you should know that. ;-)

OK. Then I guess having platform enumeration the default makes sense and
we just need to live with the ugly #ifdefs in acpi_lpss.c.
