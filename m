Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3GKCi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:38:57 -0400
Received: from ozlabs.org ([203.10.76.45]:33165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3GKCi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:38:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>, khali@linux-fr.org,
        David.Woodhouse@intel.com,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: print failure information instead of 'KOBJ_ADD' to user space, when sysfs_create_file() fails.
In-Reply-To: <51DCC426.3010606@gmail.com>
References: <51DB8597.4090101@asianux.com> <87y59gcg17.fsf@rustcorp.com.au> <51DCC426.3010606@gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 11 Jul 2013 11:23:30 +0930
Message-ID: <87k3kx50bp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang F T <chen.gang.flying.transformer@gmail.com> writes:
> On 07/09/2013 04:07 PM, Rusty Russell wrote:
>> Chen Gang <gang.chen@asianux.com> writes:
>>> When sysfs_create_file() fails, recommend to print the related failure
>>> information. And it is useless to still 'KOBJ_ADD' to user space.
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> 
>> sysfs_create_file() should not fail during boot, should it?
>> 
>
> Hmm..., please reference locate_module_kobject() in "kernel/params.c",
> which is an '__init' function, and also call sysfs_create_file(), it
> processes the related error.
>
> So I recommend to get the check too in version_sysfs_builtin().

It still can't fail.  sysfs_create_file() can fail due to OOM (not at
boot) or name duplication (not here).

You can BUG_ON() if you want.

And feel free to fix locate_module_kobject() in a separate patch.

Cheers,
Rusty.
