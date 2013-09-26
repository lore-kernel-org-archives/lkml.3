Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3IZQfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 12:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab3IZQfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:35:05 -0400
Date: Thu, 26 Sep 2013 18:34:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@kernel.org,
        peterz@infradead.org, eranian@google.com
Subject: Re: perf, x86: Add last TSX PMU code for Haswell v2
Message-ID: <20130926163412.GA9121@krava.brq.redhat.com>
References: <1379688044-14173-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379688044-14173-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 07:40:38AM -0700, Andi Kleen wrote:
> [This has kernel and user parts, so will need
> review/ack/merges from both perf kernel and user land maintainers]
> [v2: Address Peter's feedback for the kernel parts]
> 
> This is currently the last part of the TSX PMU code,
> just adding the left over bits:
> 
> This adds some changes to the user interfaces.
> I'll send patches for the manpage separately.
> 
> - Report the transaction abort flags to user space
> using a new field, and add the code to display them.
> This is used to classify abort types, also fairly
> important for tuning as it guides the tuning process,
> together with the abort weight that was added earleir.
> 
> [3 patches, generic, x86, user tools]
> 
> - Add support for reporting the two new TSX LBR flags: in_tx
> and abort_tx. The code to handle the LBRs was already
> added earlier, this just adds the code to report,
> filter and display them.
> 
> - Add a workaround for a Haswell issue that it reports
> an extra LBR record for every abort. We just filter
> those out in the kernel.
> 
> Open perf TSX issues left:
> - Revisit automatic enabling of precise for tx/el-abort
> - Need to fix the sort handling in the user tools
> to actually sort on other fields
> - The aggregated LBR display in the user tools is not 
> very useful for transactions, need a way to report them 
> in a histogram like backtraces.
> - May want some shortcut options for
> record --transaction --weight / report --sort symbol,transaction,weight
> 
> -Andi

I checked and tried (with no actuall data.. have no Haswell server)
and it seems ok

for the perf tool part:
Acked-by: Jiri Olsa <jolsa@redhat.com>


thanks,
jirka
