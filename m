Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaAUT7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:59:15 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:55461 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaAUT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:59:13 -0500
Date: Tue, 21 Jan 2014 21:58:41 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-arm-kernel@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ARM kernel (& ext3) stability issues with GCC 4.8?
Message-ID: <20140121195841.GA23238@drone.musicnaut.iki.fi>
References: <20130613220429.GC18360@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613220429.GC18360@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 14, 2013 at 01:04:29AM +0300, Aaro Koskinen wrote:
> I'm having severe stability issues with 3.10-rc5 on OpenRD (kirkwood)
> when cross-compiling it using GCC 4.8.1 (I tried also GCC 4.8.0
> with 3.9-something earlier with pretty much same results).
[...]
> [ 3383.627778] ------------[ cut here ]------------
> [ 3383.654029] kernel BUG at fs/buffer.c:2956!

It looks like the issue was caused by GCC bug 58854
(http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854).

The bug is still present in GCC 4.8.2 but there's a fix available in GCC
repository. The bug resulted in at least fs/buffer.c getting compiled
incorrectly, and what we saw were kernel crashes or file system getting
corrupted or both.

A.
