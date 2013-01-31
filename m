Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3AaV1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:27:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AaV1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:27:08 -0500
Date: Thu, 31 Jan 2013 13:27:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: xtu4 <xiaobing.tu@intel.com>
Cc: linux-kernel@vger.kernel.org, guifang.tang@intel.com,
        linX.z.chen@intel.com
Subject: Re: resend----[PATCH] Avoid high order memory allocating with
 kmalloc, when read large seq file
Message-Id: <20130131132706.f15f3166.akpm@linux-foundation.org>
In-Reply-To: <510A0B14.70800@intel.com>
References: <510768B6.3070000@intel.com>
	<510A0B14.70800@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 14:11:32 +0800
xtu4 <xiaobing.tu@intel.com> wrote:

> [SEQ_FILE] Avoid high order memory allocating with kmalloc
>   when read large seq file

The patch is still horridly mangled by your email client.

The implementation cheerfully ignores my earlier comment: "The
conventional way of doing this is to attempt the kmalloc with
__GFP_NOWARN and if that failed, fall back to vmalloc()."

This code has existed for ten years and this is the first time anyone
has encountered this problem.  Rather than mucking around with the
seq_file code to attempt to fix this, it would be better to fix the
calling code.
