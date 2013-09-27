Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab3I0CCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:02:48 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:56884 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3I0CCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130926161127.GF26159@ghostprotocols.net>
References: <1380205304-32224-1-git-send-email-artagnon@gmail.com>
 <52444F53.504@gmail.com> <CALkWK0k=c9ov-FWaR8ocD-XjUOEQWCLhv-4OjWFkJYmfMRV=QQ@mail.gmail.com>
 <20130926161127.GF26159@ghostprotocols.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 27 Sep 2013 07:32:06 +0530
Message-ID: <CALkWK0kVZ9mN5Zn+8eNHTAg3pVmuf-WcbC+XUsKFnytFffpKHw@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: remove non-existent entries in MANIFEST
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Could you please describe how it is broken?
>
> [acme@zoo linux]$ git branch | grep '*'
> * perf/urgent
> [acme@zoo linux]$ git describe
> v3.12-rc1-51-gc1bf214

Oh, I meant the torvalds/linux.git master.

  $ git describe
  v3.12-rc2-83-g4b97280
  $ make perf-tarbz2-src-pkg
    TAR
  $ tar tf perf-3.12.0-rc2.tar.bz2 | grep tools
  perf-3.12.0-rc2/tools/

As you can see, the tools/perf directory is completely missing. With
my patch applied, the archive is totally fine (and perf builds and
runs fine). I suspect the issue has to do with non-existent paths
given as the pathspec filtering argument to 'git archive'. Note that
I'm running the latest git HEAD.

Thanks.
