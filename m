Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaGUIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:16:58 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63197 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaGUIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:16:57 -0400
Message-ID: <53CCCC76.7060506@kernel.dk>
Date: Mon, 21 Jul 2014 10:16:54 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in
 bt_get()
References: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
In-Reply-To: <1405930246-2051-1-git-send-email-agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-21 10:10, Alexander Gordeev wrote:
> There is a race between __bt_get_word() and bt_clear_tag(). Since
> access to the tags bitmap is not serialized __bt_get_word() might
> miss a tag which is about to or being returned by bt_clear_tag().
> As result, the process requesting the tag might end up schedulled
> out forever.
>
> To avoid this corner case call io_schedule_timeout() instead of
> io_schedule(). The timeout should be long enough to not falsely
> wake up waiters often, so take the requests queue's "rq_timeout"
> for that.

What is this patch against?


-- 
Jens Axboe

