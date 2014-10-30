Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbaJ3Q1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:27:34 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:55961 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647AbaJ3Q1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:27:32 -0400
MIME-Version: 1.0
In-Reply-To: <545250FD.8030509@fb.com>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<yq1k33il3b3.fsf@sermon.lab.mkp.net>
	<5451A3F5.9020903@fb.com>
	<yq1bnoukzhe.fsf@sermon.lab.mkp.net>
	<545250FD.8030509@fb.com>
Date: Thu, 30 Oct 2014 09:27:31 -0700
Message-ID: <CAPcyv4gNwPrcU1CbCfUcnjqFfor5YfX6rynaoZmvEbRQMPvwMA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: Dan Williams <dan.j.williams@intel.com>
To: Jens Axboe <axboe@fb.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jason B. Akers" <jason.b.akers@intel.com>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 7:53 AM, Jens Axboe <axboe@fb.com> wrote:
> On 2014-10-29 21:28, Martin K. Petersen wrote:
>> The notion of telling the storage *why* you're doing I/O instead of
>> telling it how to manage its cache and where to put stuff is closely
>> aligned with our internal experiences with I/O hints over the last
>> decade. But it's a bit of a departure from where things are going in the
>> standards bodies. In any case I thought it was interesting that pretty
>> much every use case that people came up with could be adequately
>> described by a handful of I/O classes.
>
>
> Definitely agree on this, it's about notifying storage on what type of IO
> this is, or why we are doing it. I'm just still worried that this will then
> end up being unusable by applications, since they can't rely on anything.
> Say one vendor treats WONTNEED in a much colder fashion than others, the
> user/application will then complain about the access latencies for the next
> IO to that location. "Yes it's cold, but I didn't expect it to be THAT cold"
> and then come to the conclusion that they can't feasibly use these hints as
> they don't do exactly what they want.
>
> It'd be nice if we could augment this with a query interface of some sort,
> that could give the application some idea of what happens for each of the
> passed in hints. That would improve the situation from a "lets set this hint
> and hope it does what we think it does" to a more predictable and robust
> environment.
>

I'm skeptical we (Linux kernel) can ever get this right.  If an
application wants strict determinism in the meaning of hints it seems
it will need to qualify them against component-vendor /
platform-vendor provided transport-translation.  For this RFC we had
consumer platforms in mind where "mostly better than baseline" is the
acceptance criteria vs "hard QOS".
