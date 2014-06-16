Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaFPHEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:04:48 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47299 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaFPHEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:04:47 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 00/10] CMA: generalize CMA reserved area management code
In-Reply-To: <20140616053209.GG23210@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <87r42seyvg.fsf@linux.vnet.ibm.com> <20140616053209.GG23210@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Mon, 16 Jun 2014 12:34:14 +0530
Message-ID: <87tx7lcp3l.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061607-2674-0000-0000-0000006E43CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> On Sat, Jun 14, 2014 at 12:55:39PM +0530, Aneesh Kumar K.V wrote:
>> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>> 
>> > Currently, there are two users on CMA functionality, one is the DMA
>> > subsystem and the other is the kvm on powerpc. They have their own code
>> > to manage CMA reserved area even if they looks really similar.
>> > From my guess, it is caused by some needs on bitmap management. Kvm side
>> > wants to maintain bitmap not for 1 page, but for more size. Eventually it
>> > use bitmap where one bit represents 64 pages.
>> >
>> > When I implement CMA related patches, I should change those two places
>> > to apply my change and it seem to be painful to me. I want to change
>> > this situation and reduce future code management overhead through
>> > this patch.
>> >
>> > This change could also help developer who want to use CMA in their
>> > new feature development, since they can use CMA easily without
>> > copying & pasting this reserved area management code.
>> >
>> > v2:
>> >   Although this patchset looks very different with v1, the end result,
>> >   that is, mm/cma.c is same with v1's one. So I carry Ack to patch 6-7.
>> >
>> > Patch 1-5 prepare some features to cover ppc kvm's requirements.
>> > Patch 6-7 generalize CMA reserved area management code and change users
>> > to use it.
>> > Patch 8-10 clean-up minor things.
>> 
>> 
>> I wanted to test the ppc changes and found that the patch series doesn't apply
>> against v3.15 . Do you have a kernel tree which I can clone to test this
>> series ?
>
> This is based on linux-next -next-20140610.
> And my tree is on following link.
>
> https://github.com/JoonsooKim/linux/tree/cma-general-v2.0-next-20140610
>
> But, I think I'm late, because you have already added a Tested-by tag.

linux-next kexec is broken on ppc64, hence I hand picked few of
dependent patches for dma CMA on top of 3.15 and used that for testing.

-aneesh

