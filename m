Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3COKrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:47:41 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:65218 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3COKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:47:38 -0400
Date: Fri, 15 Mar 2013 11:47:33 +0100
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for
 ACPI-based device hotplug
Message-ID: <20130315104732.GA4401@dhcp-192-168-178-175.profitbricks.localdomain>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
 <18666371.hyHAvqrdQ6@vostro.rjw.lan>
 <20130304131023.GA4561@dhcp-192-168-178-175.profitbricks.localdomain>
 <3390139.KZuRkSrE4e@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3390139.KZuRkSrE4e@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 14, 2013 at 06:16:30PM +0100, Rafael J. Wysocki wrote:
> Sorry for the sluggish response, I've been travelling recently. ->
[...]
> > > > So, I'd suggest the following changes.
> > > >  - Remove the "uevents" attribute.  KOBJ_ONLINE/OFFLINE are not used for
> > > > ACPI device objects.
> > > >  - Make the !autoeject case as an exception for now, and emit
> > > > KOBJ_OFFLINE as a way to request off-lining to user.  This uevent is
> > > > tied with the !autoeject case.  We can then revisit if this use-case
> > > > needs to be supported going forward.  If so, we may want to consider a
> > > > different event type.
> > > 
> > > Well, what about avoiding to expose uevents and autoeject for now and
> > > exposing enabled only?  Drivers would still be able to set the other flags on
> > > init on init to enforce the backwards-compatible behavior.
> > 
> > Now that we don't define uevents and autoeject in v2 of this series, could you
> > explain how we get safe ejection from userspace e.g. for memory hot-remove? What
> > are the other flags drivers can use (on init?) to avoid autoeject and only issue
> > KOBJ_OFFLINE?
> > 
> > > 
> > > I agree that it would be sufficient to use one additional flag then, to start
> > > with, but its meaning would be something like "keep backwards compatibility
> > > with the old container driver", so perhaps "autoeject" is not a good name.
> > > 
> > > What about "user_eject" (that won't be exposed to user space) instead?  Where,
> > > if set, it would meand "do not autoeject and emit KOBJ_OFFLINE/ONLINE uevents
> > > like the old container driver did"?
> > 
> > I don't see user_eject in v2. Is it unnecessary for userspace ejection control
> > or planned for later? Also why shouldn't it be exposed to userpace?
> 
> -> At this point we are not sure if it is necessary to have an attribute for
> direct ejection control.  Since the plan is to have a separate offline/online
> attribute anyway (and a check preventing us from ejecting things that haven't
> been put offline), it is not clear how useful it is going to be to control
> ejection directly from user space.

ok.
Regarding the offline/online attribute and ejection prevention checking, do you
mean the offline/online framework from Toshi:
http://thread.gmane.org/gmane.linux.kernel/1420262
or something else? I assume this is the long-term plan.

Is there any other short-term solution planned? If i understand correctly, until
this framework is accepted, memory hot-remove is broken (=unsafe). 

thanks,

- Vasilis
