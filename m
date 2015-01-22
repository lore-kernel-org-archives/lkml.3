Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbbAVC2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:28:02 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20919 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbAVC15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:27:57 -0500
Message-ID: <54C0601D.5050006@oracle.com>
Date: Wed, 21 Jan 2015 21:27:41 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: linux-kernel@vger.kernel.org, cl@linux.com, brouer@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mm/slub: use unchecked percpu access within preemptible
 sections
References: <1421814703-1869-1-git-send-email-sasha.levin@oracle.com> <20150122015904.GF21444@js1304-P5Q-DELUXE>
In-Reply-To: <20150122015904.GF21444@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 08:59 PM, Joonsoo Kim wrote:
> On Tue, Jan 20, 2015 at 11:31:43PM -0500, Sasha Levin wrote:
>> > Commit "mm/slub: optimize alloc/free fastpath by removing preemption on/off"
>> > has added access to percpu memory while the code is preemptible.
>> > 
>> > While those accesses are okay, this creates a huge amount of warnings from
>> > the code that checks for that.
>> > 
>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> Hello,
> 
> I already sent the patch to fix this issue and it is in mmotm, but,
> not be released yet.
> 
> https://lkml.org/lkml/2015/1/19/17

The patch you sent out still has the issue. The one I sent goes on top of
it.

+	do {
+		tid = this_cpu_read(s->cpu_slab->tid); <=== checked percpu access
+		c = raw_cpu_ptr(s->cpu_slab);
+	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));


Thanks,
Sasha

