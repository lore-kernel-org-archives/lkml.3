Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaCFQet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:34:49 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:52828 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:34:48 -0500
Message-ID: <5318A3A6.1040408@tilera.com>
Date: Thu, 6 Mar 2014 11:34:46 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lu <zlu@tilera.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] tile: Add perf_events support for tile
References: <BAB94DBB0E89D8409949BC28AC95914C5D67FF08@USMAExch1.tad.internal.tilera.com>
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D67FF08@USMAExch1.tad.internal.tilera.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2014 1:09 AM, Tony Lu wrote:
> From: Zhigang Lu <zlu@tilera.com>
>
> This patchset adds perf support for tile architecture. The code is based on x86 perf event code, and it has been tested on tile for 2 years.
>
> Zhigang Lu (4):
>   tile: Add support for handling PMC hardware
>   tile: Enable NMIs on return from handle_nmi() without errors
>   tile/perf: Support perf_events on tilegx and tilepro
>   perf tools:  Allow building for tile
>
>  arch/tile/Kconfig                  |    6 +
>  arch/tile/include/asm/perf_event.h |   22 +
>  arch/tile/include/asm/pmc.h        |   64 +++
>  arch/tile/kernel/Makefile          |    2 +
>  arch/tile/kernel/intvec_32.S       |   24 +-
>  arch/tile/kernel/intvec_64.S       |   24 +-
>  arch/tile/kernel/irq.c             |   18 +
>  arch/tile/kernel/perf_event.c      | 1005 ++++++++++++++++++++++++++++++++++++
>  arch/tile/kernel/pmc.c             |  121 +++++
>  tools/perf/config/Makefile.arch    |    3 +-
>  tools/perf/perf.h                  |    8 +

Taken into the tile tree, with the wr_miss fix, given Peter's (soft) ack that it looked basically OK.  If there is more feedback we can adjust before I ask Linus to pull.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

