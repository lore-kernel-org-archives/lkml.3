Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaHNPci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:32:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41679 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbaHNPch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:32:37 -0400
MIME-Version: 1.0
In-Reply-To: <CALZtONDB5q56f1TUHgqbiJ4ZaP6Yk=GcNQw9DhvLhNyExdfQ4w@mail.gmail.com>
References: <1407978746-20587-1-git-send-email-minchan@kernel.org>
	<1407978746-20587-3-git-send-email-minchan@kernel.org>
	<CALZtONDB5q56f1TUHgqbiJ4ZaP6Yk=GcNQw9DhvLhNyExdfQ4w@mail.gmail.com>
Date: Thu, 14 Aug 2014 11:32:36 -0400
Message-ID: <CAFdhcLQ11MnF7Py+X1wrJMiu0L15-JrV883oYGopdz1oag0njQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] zram: add mem_used_max via sysfs
From: David Horner <ds2horner@gmail.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:09 AM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Wed, Aug 13, 2014 at 9:12 PM, Minchan Kim <minchan@kernel.org> wrote:
>> -       if (zram->limit_bytes &&
>> -               zs_get_total_size_bytes(meta->mem_pool) > zram->limit_bytes) {
>> +       total_bytes = zs_get_total_size_bytes(meta->mem_pool);
>> +       if (zram->limit_bytes && total_bytes > zram->limit_bytes) {
>
> do you need to take the init_lock to read limit_bytes here?  It could
> be getting changed between these checks...

There is no real danger in freeing with an error.
It is more timing than a race.

The max calculation is still ok because committed allocations are
added atomically.
