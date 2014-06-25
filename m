Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaFYLdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:33:17 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47763 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbaFYLdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:33:16 -0400
X-Yandex-Uniq: 73bb85bd-5711-44d0-9922-92e73238d17a
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Wed, 25 Jun 2014 15:33:10 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf trace: add support for pagefault tracing
Message-ID: <20140625113310.GD21788@stfomichev-desktop.yandex.net>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
 <1403103565-6388-2-git-send-email-stfomichev@yandex-team.ru>
 <20140618154751.GC2702@kernel.org>
 <20140618174254.GD15620@stfomichev-desktop.yandex.net>
 <20140618200432.GA20252@kernel.org>
 <20140619120652.GF15620@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619120652.GF15620@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also, have you considered using:
> > 
> > [root@zoo ~]# perf list exceptions:page_fault*
> >   exceptions:page_fault_user                         [Tracepoint event]
> >   exceptions:page_fault_kernel                       [Tracepoint event]
> > [root@zoo ~]#
> > 
> > Instead? I need to check if they're completely equivalent to what we
> > need here...
> Hm, didn't know there are two kinds of fault events :-/
> But it seems these are x86 only.
Maybe we can use these x86 only events to trace userspace fault duration?
It seems we can pair exceptions:page_fault_user and
context_tracking:user_enter. But it's just a theory, need to verify...
