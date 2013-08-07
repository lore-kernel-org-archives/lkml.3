Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3HGVxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:53:53 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:32979 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab3HGVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:53:52 -0400
Message-ID: <5202C1EE.40607@linuxtoys.org>
Date: Wed, 07 Aug 2013 14:53:50 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com> <5202BC11.6040605@linuxtoys.org> <20130807214010.GA5902@kroah.com>
In-Reply-To: <20130807214010.GA5902@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
>> The proxy device nodes are application specific and need to be
>> created as needed by applications.
>
> But applications do not have the permissions in a system to create
> device nodes.  Nor should they need that permission.

Agreed.  But you need root permissions to install an application
and part of that installation can be setting up systemd files
that allocate resources at boot.   Also, some applications start
as root just so they can do this kind of allocation.  The app
can (and should) drop root privileges when it can.

>
>> Allocation of minor numbers is an issue but that is an issue that
>> is separate from the proxy module itself.
> How is it separate, it seems tied directly to it as something that must
> be handled properly.
It can, but does not need to be handled in the kernel. It could
be handled in user space.

 >
 >>> Also, no, setting the permissions like this is not ok for a real system,
 >>> what is going to be in charge of setting the permissions on these random
 >>> device nodes?
 >> Again, compare proxy to a named pipe.  It is up the application
 >> writer to decide who gets read and write access to its proxy
 >> nodes.
 >
 > Ok, but to do so, you have to have root permissions to start with, which
 > is generally not going to happen on sane systems.  Only allowing root
 > access to this seems like a huge limitation.

As noted above, yes, root has to set it up and set the permissions,
but this is hardly unusual, is it?

thanks
Bob Smith

