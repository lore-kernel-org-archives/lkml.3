Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3BFLm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:42:28 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40348 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3BFLmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130205185349.GF4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<1359657696-2767-3-git-send-email-laijs@cn.fujitsu.com>
	<20130204195458.GA27963@mtj.dyndns.org>
	<5110F5DE.6030407@gmail.com>
	<20130205185349.GF4276@mtj.dyndns.org>
Date: Wed, 6 Feb 2013 19:42:24 +0800
Message-ID: <CACvQF52ej3mzwRhoGO0jmZq7GLOC_KJcxF+R2O1sqQaonYWqnw@mail.gmail.com>
Subject: Re: [PATCH 02/13] workqueue: fix work_busy()
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 2:53 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Feb 05, 2013 at 08:06:54PM +0800, Lai Jiangshan wrote:
>> >>@@ -3453,15 +3451,13 @@ unsigned int work_busy(struct work_struct *work)
>> >>  {
>> >>    struct worker_pool *pool = get_work_pool(work);
>> >>    unsigned long flags;
>> >>-   unsigned int ret = 0;
>> >>+   unsigned int ret = work_pending(work) ? WORK_BUSY_PENDING : 0;
>> >
>> >I'd prefer this as a if() statement.
>> >
>> >>    if (!pool)
>> >>-           return 0;
>> >>+           return ret;
>> >
>> >I'm a bit confused.  When can we be pending w/o pool?
>> >
>>
>> grab the pending bits <==time==> really queued
>>                       ^
>>               this patch considers the work is busy in this time
>
> Given the advisory nature of the function, why do we care?  Is it
> needed for later patches?
>

Ah, yes.

Thanks,
Lai
