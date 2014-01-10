Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbaAJT6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 14:58:18 -0500
Received: from mail.lang.hm ([64.81.33.126]:42089 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaAJT6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 14:58:16 -0500
Date: Fri, 10 Jan 2014 11:58:09 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Victor Porton <porton@narod.ru>
cc: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: Create new NetFilter table
In-Reply-To: <1171389381947@web15m.yandex.ru>
Message-ID: <alpine.DEB.2.02.1401101151390.23713@nftneq.ynat.uz>
References: <1171389381947@web15m.yandex.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Victor Porton wrote:

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

I would disagree with this idea.

If you make one special table, why would you not want others?

You would then need to define all the conditions where this table is used 
instead of, or in addition to, the existing tables.

Yes admins can shoot themselves in the foot with iptables, and any admin who 
flushes rules without understanding what is affected will probably be causing 
significant problems anyway.

Rather than doing this, have the tools that are programmatically creating rules 
also maintain a file that can be used to recreate all those rules. Then the 
Admins or init scripts can recreate things easily.

David Lang
