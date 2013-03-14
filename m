Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3CNOsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:48:25 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41412 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3CNOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:48:23 -0400
Message-ID: <1363271833.12845.186.camel@misato.fc.hp.com>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
From: Toshi Kani <toshi.kani@hp.com>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org
Date: Thu, 14 Mar 2013 08:37:13 -0600
In-Reply-To: <51418863.8000902@infracom.it>
References: <513D8F3A.8030308@gmail.com> <51418863.8000902@infracom.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 09:20 +0100, Roberto Oppedisano wrote:
> Hi
> 
> Il 11/03/2013 09:00, Roberto Oppedisano ha scritto:
> > Hello
> >     I'm observing this kind of boot failure when my laptop
> > is not docked; I didn't notice before because I seldom reboot
> > it when it's not connected to a docking station.
> >
> > The failure is reproducible at 80-90%, meaning that one boot
> > over 8-10 will complete also with the laptop undocked; it seems
> > that being attached to a power supply (via jack, not docking) or
> > on batteries makes no difference WRT this failure.

By the boot failure, are you referring the one that is partially
captured in screeshot3.png?  If so, we need full error messages (i.e.
the top of the stack trace) to see what happened. 

> following the results of a bisection:
> 
> b17b537ac1429a609addb55bf985f5ebfcf4ae7b is the first bad commit
> commit b17b537ac1429a609addb55bf985f5ebfcf4ae7b
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Jan 15 13:23:44 2013 +0100
> 
>      ACPI / scan: Drop the second argument of acpi_device_unregister()
> 
>      Drop the second argument of acpi_device_unregister(), type, which is
>      not used by that function.
> 
>      Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>      Acked-by: Toshi Kani <toshi.kani@hp.com>
>      Acked-by: Yinghai Lu <yinghai@kernel.org>
>      Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> :040000 040000 13aeb8bccbd062e65bc3710bb426fe8ac7d0cad5 
> 17d4603977ea57133d149814dc34e274ca0c2deb M      drivers
> 
> Trying to revert this commit on current master gave me an error.
> 
> Let me know if you need more info or testing.

The above patch is just a cleanup, and should have no functional
changes.  There are quite a bit of changes made around that day, so it
might be the case that other patch around that day is causing your
problem...  In any case, can you capture the full error message and send
it to us?

Thanks,
-Toshi


