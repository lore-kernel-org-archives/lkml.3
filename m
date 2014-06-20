Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbaFTPtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:49:12 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:50071 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756594AbaFTPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:49:10 -0400
X-Yandex-Uniq: 1d4a5ecd-18ec-4434-bc57-b2563299e609
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 20 Jun 2014 19:49:01 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf trace: add support for pagefault tracing
Message-ID: <20140620154901.GM15620@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <1403261389-13423-3-git-send-email-stfomichev@yandex-team.ru>
 <20140620145955.GG31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620145955.GG31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1756272.905 ( 0.000 ms): curl/5937 majfault [0x7fa7261978b6] => /usr/lib/x86_64-linux-gnu/libkrb5.so.26.0.0+0x85288 (d.)
> 
> Things like the above may be better expressed using dso@symbol+offset,
> even more when the symbol is not resolved within a DSO, due to
> insufficient expressivity in the available symtab, i.e. perhaps the user
> needs to install a debuginfo package.
Currently, the format is:
<header> <min|maj>fault [ip.symbol+ip.offset] => addr.dso+addr.offset (<mmap_type><addr.level>)

if no symbol found for IP, we have:
<header> <min|maj>fault [ip.addr] => addr.dso+addr.offset (<mmap_type><addr.level>)

mmap_type is d - for data, x - for executable vmas.

I think we may try to print [ip.dso+ip.offset] if we can't resolve ip symbol,
but I don't want dso@symbol+offset because if we have symbol, dso is
probably (?) redundant (ok, at least for me).
It also seems we don't need to resolve symbol of pagefault address
because it's either some code or some address on the heap. Dso is enough.

> > 1862866.036 ( 0.000 ms): wget/8460 majfault [__clear_user+0x3f] => 0x659cb4 (?k)
> 
> And here, where is this __clear_user symbol from? The kernel? Probaly
> that 'k' there means that? If so, probably that deserves an entry in the
> documentation.
Yes, k or . describes symbol 'level'.

> WRT documentation, please consider sending followup patches providing
> examples in the documentation, talking about the possible need of
> installing debuginfo packages as well.
I didn't put much effort into documentation because I just wanted to get
initial feedback. Will follow.

> But its shaping up nicely, good work!
Thanks.
