Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3DXLYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:24:23 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:50075 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3DXLYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <5177B061.50107@imgtec.com>
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com>
	<CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com>
	<201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
	<201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
	<51772CD3.3040405@zytor.com>
	<51772EBC.1050600@zytor.com>
	<5177B061.50107@imgtec.com>
Date: Wed, 24 Apr 2013 14:24:20 +0300
Message-ID: <CAHp75VdBd8CFSX+BZ6QBwh5a_k4jewHtraszF+PJfVDEdcMmQw@mail.gmail.com>
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, arjan@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 1:13 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 24/04/13 02:00, H. Peter Anvin wrote:
>> On 04/23/2013 05:52 PM, H. Peter Anvin wrote:

>> Either way -- James, Rusty, this is in your court.
>
> How does the patch below look? I presume this is preferred over
> making VMLINUX_SYMBOL_STR non-argument-expanding?

I will test it soon.

> Subject: [PATCH 1/1] modpost: fix unwanted VMLINUX_SYMBOL_STR expansion
>
> Commit a4b6a77b77ba4f526392612c2365797fab956014 ("module: fix symbol
> versioning with symbol prefixes") broke the MODVERSIONS loading of any
> module using memcmp (e.g. ipv6) on x86_32, as it's defined to
> __builtin_memcmp which is expanded by VMLINUX_SYMBOL_STR. Use
> __VMLINUX_SYMBOL_STR instead which doesn't expand the argument.
>
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

To be strongly correct Tetsuo and me reported about it and Tetsuo did
first analysis.

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

--
With Best Regards,
Andy Shevchenko
