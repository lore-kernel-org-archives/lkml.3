Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbaE3NwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:52:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47235 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493AbaE3NwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:52:11 -0400
Message-ID: <53888D08.1050602@kernel.dk>
Date: Fri, 30 May 2014 07:52:08 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] block: virtio_blk: don't hold spin lock during world
 switch
References: <1401418169-3361-1-git-send-email-ming.lei@canonical.com> <5387F8B2.1070509@kernel.dk> <CACVXFVPoG6_fL_MTRF+616W7UdHpSgjtMLBLeBn4OGR63haw3w@mail.gmail.com> <5387FC96.4030508@kernel.dk> <877g537q6d.fsf@rustcorp.com.au>
In-Reply-To: <877g537q6d.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-30 00:10, Rusty Russell wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>> If Rusty agrees, I'd like to add it for 3.16 with a stable marker.
>
> Really stable?  It improves performance, which is nice.  But every patch
> which goes into the kernel fixes a bug, improves clarity, improves
> performance or adds a feature.  I've now seen all four cases get CC'd
> into stable.
>
> Including some of mine explicitly not marked stable which get swept up
> by enthusiastic stable maintainers :(
>
> Is now there *any* patch short of a major rewrite which shouldn't get
> cc: stable?

I agree that there's sometimes an unfortunate trend there. I didn't 
check, but my assumption was that this is a regression after the blk-mq 
conversion, in which case I do think it belongs in stable.

But in any case, I think the patch is obviously correct and the wins are 
sufficiently large to warrant a stable inclusion even if it isn't a 
regression.

-- 
Jens Axboe

