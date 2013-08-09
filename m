Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031424Ab3HIWvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:51:39 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:39294 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031398Ab3HIWvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:51:38 -0400
Message-ID: <5205727B.7090807@linuxtoys.org>
Date: Fri, 09 Aug 2013 15:51:39 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202BC11.6040605@linuxtoys.org> <20130807214010.GA5902@kroah.com> <5202C1EE.40607@linuxtoys.org> <20130809215449.GB21756@kroah.com>
In-Reply-To: <20130809215449.GB21756@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Wed, Aug 07, 2013 at 02:53:50PM -0700, Bob Smith wrote:
>> Agreed.  But you need root permissions to install an application
>> and part of that installation can be setting up systemd files
>> that allocate resources at boot.
>
> Do you have examples of those systemd files?  Last I looked, they didn't
> have mknod permissions anymore, which is a good thing.

The difference is that Linux usually detects the hardware that is
connected to it and automatically creates device nodes for it.
This is part of the boot process.
     In the case of a userspace device driver, the kernel never sees
the hardware so it is up the USD to create the nodes for the hardware.

 >
>> Also, some applications start as root just so they can do this kind of
>> allocation.  The app can (and should) drop root privileges when it
>> can.
> You shouldn't require root for a new feature, that seems strange.

OK, but root for a new feature dealing with hardware seems OK.

 >
> Also, namespaces aren't addressed at all, but that's a totally different
> issue...

No, but I hope namespace policy can be handled in userspace and not
in the proxy module itself.

>
 > (snip)
>> As noted above, yes, root has to set it up and set the permissions,
>> but this is hardly unusual, is it?
>
> Yes it is, modern userspace does not create any device nodes anymore,
> please let's not regress on that point.

Yes, I suppose this can be viewed as a regression, but I don't see a
way around this right now.  The problem is that only the userspace
driver sees the new hardware and so knows what device nodes to create.

Once again, thanks.

Bob Smith

