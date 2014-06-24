Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaFXPVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:21:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:48927 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbaFXPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:21:13 -0400
Date: Tue, 24 Jun 2014 12:21:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf trace: add support for pagefault tracing
Message-ID: <20140624152108.GB3456@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-3-git-send-email-stfomichev@yandex-team.ru>
 <20140620145955.GG31524@kernel.org>
 <20140620154901.GM15620@stfomichev-desktop.yandex.net>
 <20140620161132.GJ31524@kernel.org>
 <20140624124620.GB16950@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624124620.GB16950@stfomichev-desktop.yandex.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 24, 2014 at 04:46:20PM +0400, Stanislav Fomichev escreveu:
> > > I think we may try to print [ip.dso+ip.offset] if we can't resolve ip symbol,
> > > but I don't want dso@symbol+offset because if we have symbol, dso is
> > > probably (?) redundant (ok, at least for me).

> > Well, I don't think it is :-)

> > dso->short_name should disambiguate 99.9% of the cases tho. Perhaps we
> > can use --verbose, as in other places, to switch using dso->long_name,
> > for cases where multiple versions of a library are used, some in non
> > standard paths, which sometimes puzzles people looking at the tools
> > output.

> If we use --verbose it will result in noise besides short/long names
> (like looking up debug symbols, etc).
> But I'm still not convinced we need to always print dso of ip, we already have
> target process and symbol (if we have dbg symbols), this should be
> enough to understand what code path triggered fault.
 
> > > It also seems we don't need to resolve symbol of pagefault address

> > Well, in some cases if we can resolve to a variable, why not?
> If we fault into data map, we resolve to nothing, right? But if we
> fault into some executable map, we can resolve some symbol. But is it
> really useful to know (because for me it's much more interesting to know
> which dso and offset we fault into, not the actual symbol)?
 
> What I think makes sense it to have current (default) format:
> [ip.sym+ip.offs] => [addr.dso.long+addr.offs]
 
> And --verbose format, which will use dso.long@symbol+offset for addr and ip.
> So by default we have somewhat readable and concise information, and if we
> need to gather all possible details we may use --verbose. What do you
> think?

We can go with that, yes.

- Arnaldo
