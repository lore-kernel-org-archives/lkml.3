Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3GKC6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:58:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1927 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3GKC6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:58:36 -0400
X-Spam-Score: -100.8
Message-ID: <51DE1F23.2090303@asianux.com>
Date: Thu, 11 Jul 2013 10:57:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>, khali@linux-fr.org,
        David.Woodhouse@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: print failure information instead of
 'KOBJ_ADD' to user space, when sysfs_create_file() fails.
References: <51DB8597.4090101@asianux.com> <87y59gcg17.fsf@rustcorp.com.au> <51DCC426.3010606@gmail.com> <87k3kx50bp.fsf@rustcorp.com.au>
In-Reply-To: <87k3kx50bp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 09:53 AM, Rusty Russell wrote:
> Chen Gang F T <chen.gang.flying.transformer@gmail.com> writes:
>> > On 07/09/2013 04:07 PM, Rusty Russell wrote:
>>> >> Chen Gang <gang.chen@asianux.com> writes:
>>>> >>> When sysfs_create_file() fails, recommend to print the related failure
>>>> >>> information. And it is useless to still 'KOBJ_ADD' to user space.
>>>> >>>
>>>> >>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> >> 
>>> >> sysfs_create_file() should not fail during boot, should it?
>>> >> 
>> >
>> > Hmm..., please reference locate_module_kobject() in "kernel/params.c",
>> > which is an '__init' function, and also call sysfs_create_file(), it
>> > processes the related error.
>> >
>> > So I recommend to get the check too in version_sysfs_builtin().
> It still can't fail.  sysfs_create_file() can fail due to OOM (not at
> boot) or name duplication (not here).
> 
> You can BUG_ON() if you want.
> 

OK, thanks, I will send patch v2 for it.


> And feel free to fix locate_module_kobject() in a separate patch.

OK, thanks, I will send related patch for it.

:-)


Thanks.
-- 
Chen Gang
