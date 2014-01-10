Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaAJTjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:39:12 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53006 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaAJTjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:39:09 -0500
Message-ID: <52D04C59.20406@quarksecurity.com>
Date: Fri, 10 Jan 2014 14:39:05 -0500
From: Joshua Brindle <brindle@quarksecurity.com>
User-Agent: Postbox 3.0.8 (Macintosh/20130427)
MIME-Version: 1.0
To: Victor Porton <porton@narod.ru>
CC: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: Create new NetFilter table
References: <1171389381947@web15m.yandex.ru>
In-Reply-To: <1171389381947@web15m.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Victor Porton wrote:
> I propose to create a new NetFilter table dedicated to rules created programmatically (not by explicit admin's iptables command).
>
> Otherwise an admin could be tempted to say `iptables -F security` which would probably break rules created for example by sandboxing software (which may follow same-origin policy to restrict one particular program to certain domain and port only). Note that in this case `iptables -F security` is a security risk (sandbox breaking)?
>
> New table could be possibly be called:
>
> - temp
> - temporary
> - auto
> - automatic
> - volatile
> - daemon
> - system
> - sys
>
> In iptables docs it should be said that this table should not be manipulated manually.

Is it possible that the solution to your sandboxing problem is seccomp 
filter?

http://outflux.net/teach-seccomp/

You'd filter out any syscall that can make outbound connections and then 
only pass already opened sockets to the sandboxed threads?

seccomp filter was actually created for sandboxing, so that user 
applications could voluntarily shed the ability to call certain syscalls 
before handling untrusted data.

