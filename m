Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbbAHAhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:37:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbbAHAhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:37:18 -0500
Date: Wed, 7 Jan 2015 16:37:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: <ionut.m.alexa@gmail.com>, <mark.yang@spreadtrum.com>,
        <wei.qiao@spreadtrum.com>, <geng.ren@spreadtrum.com>,
        <orson.zhai@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <ke.wang@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: async: Fixed the wrong waitting condition of
 wait_event
Message-Id: <20150107163717.1aba683c2bb956fc1da98e78@linux-foundation.org>
In-Reply-To: <1420428935-30385-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <async>
	<1420428935-30385-1-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015 11:35:35 +0800 Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:

> This patch changes the waitting condition of wait_event in the
> function 'async_synchronize_cookie_domain'.
> 
> This function waits until all asynchronous function calls for the certain
> domain have been done.
> 
> But, the function 'lowest_in_progress' returns the lowest *pending*
> entry's cookie.
> 
> So we should make sure that the return value of lowest_in_progress(domain)
> must be larger than @cookie.

I'm having runtime problems with this.  Twice the kernel silently hangs
late in initcalls and the third time I got a great stream of oopses.

I'll drop it.  Hopefully you'll be able to work through the bug with
Arjan and Tajun.

