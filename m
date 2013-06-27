Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3F0OXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:23:15 -0400
Received: from ozlabs.org ([203.10.76.45]:51444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab3F0OXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:23:12 -0400
Date: Fri, 28 Jun 2013 00:23:09 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Message-ID: <20130627142309.GB13867@concordia>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
 <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:35:33PM +0800, Runzhen Wang wrote:
> Power7 supports over 530 different perf events but only a small
> subset of these can be specified by name, for the remaining
> events, we must specify them by their raw code:

Hi Runzhen,

This is looking good. Sorry one last request below ...


> diff --git a/arch/powerpc/perf/power7-events-list.h b/arch/powerpc/perf/power7-events-list.h
> new file mode 100644
> index 0000000..a67e8a9
> --- /dev/null
> +++ b/arch/powerpc/perf/power7-events-list.h
> @@ -0,0 +1,548 @@
..
> +
> +EVENT(PM_IC_DEMAND_L2_BR_ALL,                 0x4898)
> +EVENT(PM_GCT_UTIL_7_TO_10_SLOTS,              0x20a0)
> +EVENT(PM_PMC2_SAVED,                          0x10022)
> +EVENT(PM_CMPLU_STALL_DFU,                     0x2003c)
> +EVENT(PM_VSU0_16FLOP,                         0xa0a4)


Can you add a leading zero to all the events that don't have a PMC, so
that they all line up vertically. It makes it a lot easier to scan the
list visually.

eg:

EVENT(PM_IC_DEMAND_L2_BR_ALL,                 0x04898)
EVENT(PM_GCT_UTIL_7_TO_10_SLOTS,              0x020a0)
EVENT(PM_PMC2_SAVED,                          0x10022)
EVENT(PM_CMPLU_STALL_DFU,                     0x2003c)
EVENT(PM_VSU0_16FLOP,                         0x0a0a4)


cheers
