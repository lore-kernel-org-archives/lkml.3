Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3JXUN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 16:13:57 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:51724 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3JXUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:13:56 -0400
Date: Thu, 24 Oct 2013 17:13:49 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix library detection when building without libelf
Message-ID: <20131024201349.GG4998@ghostprotocols.net>
References: <1382583069-26121-1-git-send-email-patrick@parcs.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382583069-26121-1-git-send-email-patrick@parcs.ath.cx>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 23, 2013 at 10:51:09PM -0400, Patrick Palka escreveu:
> When I attempt to build perf on a system with slang but without libelf,
> 'make' would wrongly complain that the slang library could not be found.
> 
> It turns out that this was happening because we are not filtering -lelf
> from EXTLIBS early enough.  As a result, the library test for slang
> (ditto for gtk, libaudit, etc) erroneously passes -lelf to try-cc, which
> of course fails on a system without libelf.
> 
> This patch makes the filtering of -lelf from EXTLIBS occur right after
> testing for libelf support, so that the subsequent library tests will
> not erroneously pass -lelf to try-cc when building without libelf
> support.

Can you please check with the perf/core branch in my tree or Ingo's?

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core

or Ingo's:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core

The feature detection was reworked and perhaps it is fixed there.

- Arnaldo
