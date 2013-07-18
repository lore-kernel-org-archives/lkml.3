Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3GRGuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:50:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51726 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab3GRGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:50:06 -0400
Date: Thu, 18 Jul 2013 07:49:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: linux@horizon.com, Jiri Kosina <jkosina@suse.cz>,
        andriy.shevchenko@linux.intel.com, andrei.emeltchenko@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf.c: fix the incorrect return value of
 vsnprintf()
Message-ID: <20130718064953.GX4165@ZenIV.linux.org.uk>
References: <51E78B21.50907@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E78B21.50907@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 02:28:49PM +0800, Chen Gang wrote:
> When "str >= end", necessary to reset 'str' to "end - 1", or the return
> value will be larger than the real one, the callers which depend on the
> return value, may cause memory overflow.

You do realize that snprintf(s, 1, "abc") should return 3, not 1?  The
goal off snprintf() is _not_ just to truncate the output; return value
tells how much should the buffer had been to fit the whole thing.
