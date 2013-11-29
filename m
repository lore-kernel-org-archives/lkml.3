Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3K2WWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:22:39 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:34695 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3K2WWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:22:38 -0500
Date: Fri, 29 Nov 2013 17:22:35 -0500
From: Tejun Heo <tj@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000098
Message-ID: <20131129222235.GJ21755@mtj.dyndns.org>
References: <20131126092152.GF17626@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126092152.GF17626@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 05:21:52PM +0800, Yuanhan Liu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 98de48a0e011f2ef497a0f0c40b79169198cf797
> Author:     Tejun Heo <tj@kernel.org>
> AuthorDate: Sat Nov 23 18:01:54 2013 -0500
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Sat Nov 23 18:01:54 2013 -0500
> 
>     sysfs, kernfs: make sysfs_dirent definition public
...
> [    0.372911] BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
> [    0.374091] IP: [<ffffffff812fdbbb>] kobject_add_internal+0x1cb/0x6c0

This was from the patch incorrectly replacing dummy noop
implementation for !CONFIG_SYSFS with the actual implementation.
Updated patches posted.

Thank you very much!

-- 
tejun
