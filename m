Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaKUGsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:48:21 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49136 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaKUGsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:48:19 -0500
Date: Fri, 21 Nov 2014 06:48:49 +0000
From: Minchan Kim <minchan@kernel.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mm/zsmalloc: remove unnecessary check
Message-ID: <20141121064849.GA17181@gmail.com>
References: <1416489716-9967-1-git-send-email-opensource.ganesh@gmail.com>
 <20141121035442.GB10123@bbox>
 <CADAEsF975+a6Y5dcEu1B2OscQ5JaxD+ZQ1jnFOJ115BXgMqULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADAEsF975+a6Y5dcEu1B2OscQ5JaxD+ZQ1jnFOJ115BXgMqULA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:33:26PM +0800, Ganesh Mahendran wrote:
> Hello
> 
> 2014-11-21 11:54 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> > On Thu, Nov 20, 2014 at 09:21:56PM +0800, Mahendran Ganesh wrote:
> >> ZS_SIZE_CLASSES is calc by:
> >>   ((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / ZS_SIZE_CLASS_DELTA + 1)
> >>
> >> So when i is in [0, ZS_SIZE_CLASSES - 1), the size:
> >>   size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA
> >> will not be greater than ZS_MAX_ALLOC_SIZE
> >>
> >> This patch removes the unnecessary check.
> >
> > It depends on ZS_MIN_ALLOC_SIZE.
> > For example, we would change min to 8 but MAX is still 4096.
> > ZS_SIZE_CLASSES is (4096 - 8) / 16 + 1 = 256 so 8 + 255 * 16 = 4088,
> > which exceeds the max.
> Here, 4088 is less than MAX(4096).
> 
> ZS_SIZE_CLASSES = (MAX - MIN) / Delta + 1
> So, I think the value of
>     MIN + (ZS_SIZE_CLASSES - 1) * Delta =
>     MIN + ((MAX - MIN) / Delta) * Delta =
>     MAX
> will not exceed the MAX

You're right. It was complext math for me.
I should go back to elementary school.

Thanks!

Acked-by: Minchan Kim <minchan@kernel.org>


