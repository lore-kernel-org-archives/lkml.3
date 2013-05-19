Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3ESQG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 12:06:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9229 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3ESQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 12:06:24 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VaqywNGxpRkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=l0Yg3AS2bs0A:10 a=Qvhn1tVB04y2xbDhawsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368979579.6828.114.camel@gandalf.local.home>
Subject: Re: [PATCH v2 10/10] kernel: might_fault does not imply might_sleep
From: Steven Rostedt <rostedt@goodmis.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, David Howells <dhowells@redhat.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        microblaze-uclinux@itee.uq.edu.au, linux-am33-list@redhat.com,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org
Date: Sun, 19 May 2013 12:06:19 -0400
In-Reply-To: <20130519133418.GA24381@redhat.com>
References: <cover.1368702323.git.mst@redhat.com>
	 <1f85dc8e6a0149677563a2dfb4cef9a9c7eaa391.1368702323.git.mst@redhat.com>
	 <20130516184041.GP19669@dyad.programming.kicks-ass.net>
	 <20130519093526.GD19883@redhat.com>
	 <1368966844.6828.111.camel@gandalf.local.home>
	 <20130519133418.GA24381@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-05-19 at 16:34 +0300, Michael S. Tsirkin wrote:

> Right but we need to keep it working on upstream as well.
> If I do preempt_enable under a spinlock upstream won't it
> try to sleep under spinlock?

No it wont. A spinlock calls preempt_disable implicitly, and a
preempt_enable() will not schedule unless preempt_count is zero, which
it wont be under a spinlock.

If it did, there would be lots of bugs all over the place because this
is done throughout the kernel (a preempt_enable() under a spinlock).

In other words, don't ever use preempt_enable_no_resched().

-- Steve


