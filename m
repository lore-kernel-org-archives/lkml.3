Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaCRAUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:20:17 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:52586 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaCRAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:20:14 -0400
Message-ID: <1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [tip:x86/urgent] x86 idle: Repair large-server 50-watt
 idle-power regression
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 17 Mar 2014 17:20:10 -0700
In-Reply-To: <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
	 <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 11:51 -0800, tip-bot for Len Brown wrote:
> Commit-ID:  40e2d7f9b5dae048789c64672bf3027fbb663ffa
> Gitweb:     http://git.kernel.org/tip/40e2d7f9b5dae048789c64672bf3027fbb663ffa
> Author:     Len Brown <len.brown@intel.com>
> AuthorDate: Wed, 18 Dec 2013 16:44:57 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 19 Dec 2013 11:47:39 -0800
> 
> x86 idle: Repair large-server 50-watt idle-power regression

FYI this commit can cause some non trivial performance regressions for
larger core count systems. While not surprising because of the nature of
the change, having intel_idle do more cacheline invalidations, I still
wanted to let you guys know. For instance, on a 160 core Westmere
system, aim7 throughput can go down in a number of tests, anywhere from
-10% to -25%.

I guess it comes down to one of those performance vs energy things. And
sure, max_cstate can be set to overcome this, but it's still something
that was previously taken for granted.

Thanks,
Davidlohr

