Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaBJNxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:53:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaBJNx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:53:28 -0500
Date: Mon, 10 Feb 2014 14:52:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, dave.hansen@intel.com, torvalds@linux-foundation.org,
        peter@hurleysoftware.com, alex.shi@linaro.org, riel@redhat.com,
        arnd@arndb.de, figo1802@gmail.com, akpm@linux-foundation.org,
        matthew.r.wilcox@intel.com, aarcange@redhat.com, tglx@linutronix.de,
        scott.norton@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        andi@firstfloor.org, davidlohr.bueso@hp.com, waiman.long@hp.com,
        will.deacon@arm.com, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        linux@horizon.com, walken@google.com, aswin@hp.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking/mcs: Order the header files in Kbuild
 of each architecture in alphabetical order
Message-ID: <20140210135237.GM9987@twins.programming.kicks-ass.net>
References: <tip-b119fa61d440fe0f5af504299ad506637585a8ca@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-b119fa61d440fe0f5af504299ad506637585a8ca@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:32:32AM -0800, tip-bot for Tim Chen wrote:

This script is actually buggy and lost some headers; the fixed version
is as follows:

> for i in arch/*/include/asm/Kbuild
> do
>         cat $i | gawk '/^generic-y/ {
>                 i = 3;
>                 do {
			n = NF;
                        for (; i <= n; i++) {
>                                 if ($i == "\\") {
>                                         getline;
                                         i = 0;
>                                         continue;
>                                 }
>                                 if ($i != "")
>                                         hdr[$i] = $i;
>                         }
>                         break;
>                 } while (1);
>                 next;
>         }
>         // {
>                 print $0;
>         }
>         END {
>                 n = asort(hdr);
>                 for (i = 1; i <= n; i++)
>                         print "generic-y += " hdr[i];
>         }' > ${i}.sorted;
>         mv ${i}.sorted $i;
> done
