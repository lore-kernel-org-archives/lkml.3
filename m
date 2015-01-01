Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbbAAAwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:52:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbAAAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:52:52 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUXarbLJt5yL_JJHntDFRkBZyvNMHxUGcOLNjULUQ8FhHw@mail.gmail.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<CA+icZUV17qR-kBRnYa+r0DfchQ0QtaBy-6c3f3QuXn0EGwuJzQ@mail.gmail.com>
	<54A4703B.2000006@oracle.com>
	<CA+icZUXarbLJt5yL_JJHntDFRkBZyvNMHxUGcOLNjULUQ8FhHw@mail.gmail.com>
Date: Thu, 1 Jan 2015 08:52:49 +0800
Message-ID: <CACVXFVP+30g1k8nf3FR1ZFg=CBay_yg=guZfoM+DFdco64AhyQ@mail.gmail.com>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
From: Ming Lei <ming.lei@canonical.com>
To: sedat.dilek@gmail.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 6:35 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Dec 31, 2014 at 10:52 PM, Dave Kleikamp
> <dave.kleikamp@oracle.com> wrote:
>> On 12/31/2014 02:38 PM, Sedat Dilek wrote:
>>>
>>> What has happened to that aio_loop patchset?
>>> Is it in Linux-next?
>>> ( /me started to play with "block: loop: convert to blk-mq (v3)", so I
>>> recalled this other improvement. )
>>
>> It met with some harsh resistance, so I backed off on it. Then Al Viro
>> got busy re-writing the iov_iter infrastructure and I put my patchset on
>> the shelf to look at later. Then Ming Lei submitted more up-to-date
>> patchset: https://lkml.org/lkml/2014/8/6/175
>>
>> It looks like Ming is currently only pushing the first half of that
>> patchset. I don't know what his plans are for the last three patches:
>>
>> aio: add aio_kernel_() interface
>> fd/direct-io: introduce should_dirty for kernel aio
>> block: loop: support to submit I/O via kernel aio based
>>
>
> I tested with block-mq-v3 (for next-20141231) [1] and this looks promising [2].
>
> Maybe Ming can say what the plan is with the missing parts.

I have compared kernel aio based loop-mq(the other 3 aio patches
against loop-mq v2, [1]) with loop-mq v3, looks the data isn't
better than loop-mq v3.

kernel aio based approach requires direct I/O, at least direct write
shouldn't be good as page cache write, IMO.

So I think we need to investigate kernel aio based approach further
wrt. loop improvement.

[1] http://marc.info/?l=linux-kernel&m=140941494422520&w=2

Thanks,
Ming Lei
>
> - Sedat -
>
> [1] http://marc.info/?l=linux-kernel&m=142003226701471&w=2
> [2]http://marc.info/?l=linux-kernel&m=142006516408381&w=2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
