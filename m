Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaD1XbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:31:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54887 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756284AbaD1XbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:31:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mroos@linux.ee, viresh.kumar@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Cpufreq frequency serialization fixes
Date: Tue, 29 Apr 2014 01:47:33 +0200
Message-ID: <9665161.ytKRFCMQPA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 12:23:54 AM Srivatsa S. Bhat wrote:
> 
> Hi,
> 
> Meelis Roos reported hangs during boot in the longhaul cpufreq driver, after
> commit 12478cf0c55 (cpufreq: Make sure frequency transitions are serialized).
> The root-cause of this issue is the extra invocation of the
> cpufreq_freq_transition_begin() and cpufreq_freq_transition_end() APIs in the
> longhaul driver. I found similar issues in the powernow-k6 and powernow-k7
> drivers as well. This patchset fixes the issue in all the 3 drivers and also
> adds a debug infrastructure to catch such issues easily.
> 
> Patches 1-4 fix the regression in longhaul, powernow-k6 and powernow-k7
> drivers. (Patch 2 fixes a different bug in powernow-k6, and it is kept as a
> separate patch instead of merging it with patch 3, because I felt that it was
> a bit subtle and needed attention in a separate patch).
> 
> Patch 5 adds a debug infrastructure to the cpufreq core to catch such problems
> more easily in the future.

I've queued up patches [1-4/5] for 3.15, the last one I need to have another
look at tomorrow.

BTW, when you fix regressions, please always add a Fixes: tag to the changelog.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
