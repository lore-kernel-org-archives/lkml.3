Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3GRH1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:27:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65511 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3GRH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:27:49 -0400
X-AuditID: 9c930179-b7c49ae000000e68-e7-51e798f38fb8
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 02/23] perf tools: Remove data_offset seek as it's not needed
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
	<1374083403-14591-3-git-send-email-jolsa@redhat.com>
Date: Thu, 18 Jul 2013 16:27:47 +0900
In-Reply-To: <1374083403-14591-3-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 17 Jul 2013 19:49:42 +0200")
Message-ID: <87li54wcng.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 19:49:42 +0200, Jiri Olsa wrote:
> Removing data_offset seek as it's not needed, because
> data are not read by syscall but mmaped instead.

Yes we do, but it's not mandatory, right?  I'd rather expect the file
offset remains at the beginning of data after calling
perf_session__read_header() instead of a random point (EOF?).

Thanks,
Namhyung
