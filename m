Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaAHQfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:35:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35758 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbaAHQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:35:12 -0500
Message-ID: <52CD7E0B.6020606@kernel.dk>
Date: Wed, 08 Jan 2014 09:34:19 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [block:for-3.14/core]: bio_endio: Warn and free bio if bi_end_io
 is not set.
References: <CAFR8uecjVRQg5S9RKKjZQ+t+7jFVed_T1BhhdXJFO60EK=9XGw@mail.gmail.com>
In-Reply-To: <CAFR8uecjVRQg5S9RKKjZQ+t+7jFVed_T1BhhdXJFO60EK=9XGw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 06:57 PM, Muthu Kumar wrote:
> Jens,
> In bio_endio if bio doesn't have bi_end_io (should be an error case),
> we set bio to NULL and continue silently without freeing the bio. It
> would be good to have a WARN and free the bio to avoid memory leak.
> 
> If you agree, here is the patch.

I don't remember off the top of my head if there are valid uses cases of
it. But leaking it would definitely be problematic. So I think it's a
good idea to queue it up, then we'll see if it triggers anything.

-- 
Jens Axboe

