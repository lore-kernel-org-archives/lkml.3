Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3JRRUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:20:39 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49995 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab3JRRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:20:37 -0400
Message-ID: <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Fri, 18 Oct 2013 10:20:35 -0700
In-Reply-To: <20131018165034.GC4019@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131017003421.GA31470@hmsreliant.think-freely.org>
	 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
	 <20131018165034.GC4019@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 12:50 -0400, Neil Horman wrote:
> > 

> 	for(i=0;i<100000;i++) {
> 		sum = csum_partial(buf+offset, PAGE_SIZE, sum);
> 		offset = (offset < BUFSIZ-PAGE_SIZE) ? offset+PAGE_SIZE  : 0;
> 	}

Please replace this by random accesses, and use the more standard 1500
length.

offset = prandom_u32() % (BUFSIZ - 1500);
offset &= ~1U;

sum = csum_partial(buf + offset, 1500, sum);

You are basically doing sequential accesses, so prefetch should
be automatically done by cpu itself.

Thanks !


