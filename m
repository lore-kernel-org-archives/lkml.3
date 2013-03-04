Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab3CDVYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:24:13 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53290 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab3CDVXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:23:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130304174254.GF8913@agk.fab.redhat.com>
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
	<20130304174254.GF8913@agk.fab.redhat.com>
Date: Mon, 4 Mar 2013 13:23:54 -0800
Message-ID: <CAKwO_5GwN8PCtK6tM=KWvZMJHb357O+Bh3TpF3k3vB_0x_FtpQ@mail.gmail.com>
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
From: Paul Taysom <taysom@google.com>
To: Paul Taysom <taysom@chromium.org>, agk@redhat.com, dm-devel@redhat.com,
        neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 9:42 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, Mar 04, 2013 at 08:45:48AM -0800, Paul Taysom wrote:
>> @@ -449,8 +468,14 @@ static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
>>                               hash_block_end = v->hash_blocks - 1;
>>               }
>>  no_prefetch_cluster:
>> -             dm_bufio_prefetch(v->bufio, hash_block_start,
>> -                               hash_block_end - hash_block_start + 1);
>> +             vw = kmalloc(sizeof(*vw), GFP_KERNEL);
>
> kmalloc?  mempool? ...
>
> Alasdair
>
The use of mempool would be a separate patch that would have to be
measured for performance impact.
-Paul
