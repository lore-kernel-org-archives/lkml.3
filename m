Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3KZLFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:05:47 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:41645 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756122Ab3KZLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:05:46 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 26 Nov 2013 15:05:36 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131126110536.GC3388@stfomichev-desktop>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125182139.GD20168@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This makes the new tool stop processing old files, can you try the patch
> attached instead?
I see two downsides to your approach:
1) with your patch I'm now required to run 'perf timechart record' and
'perf timechart' on the same machine (otherwise, on the 'perf timechart'
machine we may have wrong fields definitions that don't match perf.data).
Currently, it's possible to use 'perf timechart record' on the target and do
'perf timechart' on the host (at least I do it this way).
2) only root can run 'perf timechart' now (because of permissions on
/sys/kernel/debug).

Maybe we can we make some simple version check against the perf.data file and
just refuse to process the old one (not sure if it's possible)?

> Its only compile tested tho.
Ok, I'll test it if we are fine with the new limitations.
