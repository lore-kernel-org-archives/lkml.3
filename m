Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258Ab3IDRdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:33:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:60230 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763175Ab3IDRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:33:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130904150854.GF3996@quack.suse.cz>
References: <cover.1377193658.git.luto@amacapital.net> <20130904150854.GF3996@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 10:33:22 -0700
Message-ID: <CALCETrVayD1P2a8ShjZ2e4HYGwL_yE8FM7GnrWaL9MgXYMGvHg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 8:08 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 22-08-13 17:03:16, Andy Lutomirski wrote:
>> Writes via mmap currently update mtime and ctime in ->page_mkwrite.
>> This hurts both throughput and latency.  In workloads that dirty a
>> large number of mmapped pages, ->page_mkwrite can be hot and
>> file_update_time is slow and scales poorly.  Updating timestamps can
>> also sleep, which hurts latency for real-time workloads.
>   It would help to make your case if you posted the latency comparison
> before & after the patchset in this introductory email. We can then see
> how significant is the reduction of latency...

Will do, although the data from my workload will be a little strange.

I was hoping that Dave Hansen would re-run his benchmark with these
patches applied.  I tried to run it, but it wasn't obvious what the
numbers that spewed out meant.

--Andy

>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR



-- 
Andy Lutomirski
AMA Capital Management, LLC
