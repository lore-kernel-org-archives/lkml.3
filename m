Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3JNVTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:19:25 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:48741 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3JNVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:19:23 -0400
Message-ID: <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Mon, 14 Oct 2013 14:19:20 -0700
In-Reply-To: <20131014202854.GH26880@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	 <20131012172124.GA18241@gmail.com>
	 <20131014202854.GH26880@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-14 at 16:28 -0400, Neil Horman wrote:

> So, early testing results today.  I wrote a test module that, allocated a 4k
> buffer, initalized it with random data, and called csum_partial on it 100000
> times, recording the time at the start and end of that loop.  Results on a 2.4
> GHz Intel Xeon processor:
> 
> Without patch: Average execute time for csum_partial was 808 ns
> With patch: Average execute time for csum_partial was 438 ns

Impressive, but could you try again with data out of cache ?



