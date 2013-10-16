Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab3JPAeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:34:14 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57945 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828Ab3JPAeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:34:13 -0400
Message-ID: <1381883650.2045.92.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date: Tue, 15 Oct 2013 17:34:10 -0700
In-Reply-To: <1381854064.22110.16.camel@joe-AO722>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
	 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790278.16896.2.camel@joe-AO722>
	 <1381790686.2045.24.camel@edumazet-glaptop.roam.corp.google.com>
	 <1381790982.16896.7.camel@joe-AO722> <20131015074123.GB25493@gmail.com>
	 <1381854064.22110.16.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 09:21 -0700, Joe Perches wrote:

> Ingo, Eric _showed_ that the prefetch is good here.
> How about looking at a little optimization to the minimal
> prefetch that gives that level of performance.

Wait a minute, my point was to remind that main cost is the
memory fetching.

Its nice to optimize cpu cycles if we are short of them,
but in the csum_partial() case, the bottleneck is the memory.

Also I was wondering on the implications of changing reads order,
as it might fool cpu predictions.

I do not particularly care about finding the right prefetch stride,
I think Intel guys know better than me.


