Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaFTQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:19:12 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47519 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753833AbaFTQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:19:09 -0400
X-Yandex-Uniq: de669ad7-ef29-4a76-a8f9-354881c61d06
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 20 Jun 2014 20:18:59 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140620161859.GN15620@stfomichev-desktop.yandex.net>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
 <20140620132105.GE31524@kernel.org>
 <20140620150318.GK15620@stfomichev-desktop.yandex.net>
 <20140620152449.GH31524@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620152449.GH31524@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hey, haven't you seen the vfs_getname probe? Idea is to hook on where
> the relevant copy_from_user is done and insert that into the ring
> buffer, as we already do for mapping fd -> pathname.
I saw it but didn't actually try because it needs all the debugging
stuff enabled and in place.

> I.e. no need for actual tracepoints from day one, just wannabe
> tracepoints using whatever probe inserting gizmo the kprobes_tracer used
> by 'perf probe' now thinks its best to use.
But we then need to predefine many probes for decoding to work in the form of
func:offset, and then play catch-up with all the kernel changes.
Or I miss something important here?

> For now try:
> 
>   perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
>   trace
> 
> And look at how it manages to decode fds.
I will try, but does 65 still work after c4ad8f98bef77c7356aa6a9ad9188a6acc6b849d? :-)
