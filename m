Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaCXT60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:58:26 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46084 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaCXT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:58:24 -0400
Message-ID: <53308E5D.1050800@kernel.dk>
Date: Mon, 24 Mar 2014 12:58:21 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Monam Agarwal <monamagarwal123@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Use RCU_INIT_POINTER(x, NULL) in blk-ioc.c
References: <1395520154-2815-1-git-send-email-monamagarwal123@gmail.com>
In-Reply-To: <1395520154-2815-1-git-send-email-monamagarwal123@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-22 13:29, Monam Agarwal wrote:
> This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
>
> The rcu_assign_pointer() ensures that the initialization of a structure
> is carried out before storing a pointer to that structure.
> And in the case of the NULL pointer, there is no structure to initialize.
> So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

What's the point of further complicating the API for cases where we 
don't even really care about performance?

-- 
Jens Axboe

