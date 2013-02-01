Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3BAD2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:28:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3BAD2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:28:05 -0500
MIME-Version: 1.0
In-Reply-To: <1359688835.15911.4.camel@joe-AO722>
References: <1359688060-12964-1-git-send-email-ming.lei@canonical.com>
	<1359688835.15911.4.camel@joe-AO722>
Date: Fri, 1 Feb 2013 11:28:02 +0800
Message-ID: <CACVXFVPQ9d1K86R0ebZc5OPtvDs-_Hk=GtEZy5mo0wzZstRQVA@mail.gmail.com>
Subject: Re: [PATCH] block: partition: optimize memory allocation in check_partition
From: Ming Lei <ming.lei@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 11:20 AM, Joe Perches <joe@perches.com> wrote:
>> @@ -15,13 +15,15 @@ struct parsed_partitions {
>>               int flags;
>>               bool has_info;
>>               struct partition_meta_info info;
>> -     } parts[DISK_MAX_PARTS];
>> +     } *parts;
>
> This is relatively unusual style.
> Could you break out this struct instead?

IMO, looks it isn't necessary since no one uses the type of the embedded
structure directly, and the style isn't introduced by this patch, which only
follows the previous one.

Thanks,
--
Ming Lei
