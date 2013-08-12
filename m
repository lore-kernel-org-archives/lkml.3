Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3HLDSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 23:18:52 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:42820 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755739Ab3HLDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 23:18:44 -0400
Date: Sun, 11 Aug 2013 23:19:52 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Michael Ellerman <michael@ellerman.id.au>
cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] powerpc/perf: Define big-endian version of
 perf_mem_data_src
In-Reply-To: <20130811235758.GA29824@concordia>
Message-ID: <alpine.DEB.2.02.1308112308040.16609@pianoman.cluster.toy>
References: <20130810174831.GA15551@us.ibm.com> <20130810175153.GF15551@us.ibm.com> <alpine.DEB.2.02.1308102232120.4119@pianoman.cluster.toy> <20130811235758.GA29824@concordia>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.52085413.00D3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Michael Ellerman wrote:
> 
> Yes I think so. The interface is already defined and it's little endian,
> so on big endian we just need to swap.
> 
> The only part I'm not clear on is how things are handled in perf
> userspace, it seems to already do some byte swapping.

It would be nice to clarify this.

"struct perf_branch_entry" also has bitfields like this, though to make
things more confusing that structure isn't exported via the uapi header
so it's not clear how userspace code is supposed to interpret the values.

As you say it gets complicated with perf userspace, especially in cases
where you record the data on big-endian but then try to analyze the
results on a little-endian machine.

It would be nice to get confirmation that these bitfields will always be 
little-endian.  I guess they currently are by definition because only 
x86/pebs sets data.data_src.val so far?

Vince

