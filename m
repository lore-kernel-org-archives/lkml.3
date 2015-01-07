Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbbAGU7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:59:32 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41971 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbAGU7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:59:30 -0500
Date: Wed, 7 Jan 2015 12:59:26 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/3] mtd:mtdblock: remove the needless mtdblks_lock
Message-ID: <20150107205926.GO9759@ld-irv-0074>
References: <547E7348.5020204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547E7348.5020204@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:19:52AM +0800, Gu Zheng wrote:
> The global lock mtdblks_lock was used to protect the original mtdblks
> array to avoid race conditions. As the mtdblks array was already gone,
> but the mtdblks_lock is left, and it causes latency when open/release dev.
> So we need to remove it here.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Pushed this first patch to l2-mtd.git. Thanks!

I'm kinda ambivalent about the next two. They don't seem like necessary
cleanups, really. With the third patch, I think it's actually pretty
important that the caller understand that it's using container_of(). I
could be convinced otherwise though...

Brian
