Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaEVRQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:16:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54884 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaEVRQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:16:41 -0400
Message-ID: <537E30AF.4070501@zytor.com>
Date: Thu, 22 May 2014 10:15:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com> <1400777250-17335-17-git-send-email-will.deacon@arm.com>
In-Reply-To: <1400777250-17335-17-git-send-email-will.deacon@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 09:47 AM, Will Deacon wrote:
> write{b,w,l,q}_relaxed are implemented by some architectures in order to
> permit memory-mapped I/O accesses with weaker barrier semantics than the
> non-relaxed variants.
> 
> This patch adds dummy macros for the read and write accessors to x86,
> which simply expand to the non-relaxed variants. Note that this
> strengthens the relaxed read accessors, since they are now ordered with
> respect to each other by way of a compiler barrier.

OK, do we want/need that compiler barrier?  And you say "strengthens" -
strengthens with respect to what if we didn't have them before?

	-hpa

