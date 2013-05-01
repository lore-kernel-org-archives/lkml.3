Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3EAIFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 04:05:34 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45454 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3EAIFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 04:05:23 -0400
Message-ID: <5180CCC0.8070703@kernel.org>
Date: Wed, 01 May 2013 11:05:20 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, glommer@parallels.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
References: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp> <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
In-Reply-To: <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/13 8:27 PM, Christoph Lameter wrote:
>> "kmalloc() returning NULL for these allocations" is needed by "try kmalloc()
>> first, fallback to vmalloc()" allocation. There are kernel modules which expect
>> kmalloc() to return NULL rather than oops when the requested size is larger
>> than KMALLOC_MAX_SIZE bytes. If kmalloc() suddenly starts triggering oops, such
>> modules will break.
>
> This behavior has been in there for years. Why try a kmalloc that
> always fails since the size is too big?

...because want the extra protection for cases where size is controlled 
by userspace. This is consistent with kcalloc() that returns NULL on 
integer overflow.

			Pekka
