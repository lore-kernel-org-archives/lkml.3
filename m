Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaFVR0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 13:26:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFVR0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 13:26:12 -0400
MIME-Version: 1.0
Message-ID: <1acfd8b6-48f1-4324-9723-224a7f4f7367@default>
Date: Sun, 22 Jun 2014 10:25:50 -0700 (PDT)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <bp@alien8.de>
Cc: <tony.luck@intel.com>, <mattieu.souchaud@free.fr>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- bp@alien8.de wrote:

> On Fri, Jun 20, 2014 at 10:04:37PM -0400, Boris Ostrovsky wrote:
> > I'll try it later but this doesn't look sufficient to me: we might
> not
> > reach this point if subsys_system_register() or
> zalloc_cpumask_var()
> > fail.
> 
> If those fail, I'd say we have a much bigger problem than undeleted
> timers.


You can add 

Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

if you prefer to go with that version. I still think it's not 100% reliable (because of what I said above) but at least it fixes the current breakage.

> 
> > We could register the notifier as the first thing in this routine
> > (probably after mce_available() succeeds).
> 
> I guess...


Actually that won't work --- we need to register bus at sysfs first.

-boris
