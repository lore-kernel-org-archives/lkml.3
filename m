Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3GRGx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:53:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14267 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab3GRGxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:53:24 -0400
X-Spam-Score: -100.8
Message-ID: <51E790A5.3020006@asianux.com>
Date: Thu, 18 Jul 2013 14:52:21 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux@horizon.com, Jiri Kosina <jkosina@suse.cz>,
        andriy.shevchenko@linux.intel.com, andrei.emeltchenko@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/vsprintf.c: fix the incorrect return value of vsnprintf()
References: <51E78B21.50907@asianux.com> <20130718064953.GX4165@ZenIV.linux.org.uk>
In-Reply-To: <20130718064953.GX4165@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 02:49 PM, Al Viro wrote:
> On Thu, Jul 18, 2013 at 02:28:49PM +0800, Chen Gang wrote:
>> > When "str >= end", necessary to reset 'str' to "end - 1", or the return
>> > value will be larger than the real one, the callers which depend on the
>> > return value, may cause memory overflow.
> You do realize that snprintf(s, 1, "abc") should return 3, not 1?  The
> goal off snprintf() is _not_ just to truncate the output; return value
> tells how much should the buffer had been to fit the whole thing.
> 
> 

It is my fault, thanks.

-- 
Chen Gang
