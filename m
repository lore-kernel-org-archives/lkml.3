Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3GRGmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:42:42 -0400
Received: from science.horizon.com ([71.41.210.146]:63383 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755265Ab3GRGmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:42:40 -0400
Date: 18 Jul 2013 02:42:38 -0400
Message-ID: <20130718064238.25532.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andrei.emeltchenko@intel.com, andriy.shevchenko@linux.intel.com,
        gang.chen@asianux.com, jkosina@suse.cz, linux@horizon.com
Subject: Re: [PATCH] lib/vsprintf.c: fix the incorrect return value of vsnprintf()
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <51E78B21.50907@asianux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When "str >= end", necessary to reset 'str' to "end - 1", or the return
> value will be larger than the real one, the callers which depend on the
> return value, may cause memory overflow.

NAK.  This is the documented (by both the function itself and the
ANSI/ISO C standard) and desired return value: the number of bytes that
*would* have been in the output string if the buffer were large enough.
In particular, it is common to do:

size = vsnprintf(NULL, 0, fmt, args) + 1;
p = malloc(size, GFP_KERNEL);
vsnprintf(p, size, fmt, args);

You want vscnprintf.  If you have a caller that needs the *actual* number of
bytes written, use that.
