Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab3HGV3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:29:02 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:55674 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3HGV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:29:01 -0400
Message-ID: <5202BC11.6040605@linuxtoys.org>
Date: Wed, 07 Aug 2013 14:28:49 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org> <20130803223828.GA14611@kroah.com> <51FECDA6.5070001@linuxtoys.org> <20130804231958.GA25418@kroah.com> <52003958.7080103@linuxtoys.org> <20130806094604.GE27889@kroah.com> <520299AB.1020607@linuxtoys.org> <20130807192714.GC2708@kroah.com> <5202A284.7010106@linuxtoys.org> <20130807195427.GB4121@kroah.com>
In-Reply-To: <20130807195427.GB4121@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
 > You ignored my mknod comment.
Yes, proxy is a type of IPC.  It's closest counterpart in the
kernel now is a named pipe.   The kernel does not try to create
named pipes automatically.  Named pipes are created deliberately
by users with the mkfifo command or system call. Same with proxy.
The proxy device nodes are application specific and need to be
created as needed by applications.

Allocation of minor numbers is an issue but that is an issue that
is separate from the proxy module itself.


 > Also, no, setting the permissions like this is not ok for a real system,
 > what is going to be in charge of setting the permissions on these random
 > device nodes?
Again, compare proxy to a named pipe.  It is up the application
writer to decide who gets read and write access to its proxy
nodes.


thanks
Bob Smith
