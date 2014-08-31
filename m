Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaHaOoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 10:44:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:10031 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaHaOoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 10:44:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="379442429"
Message-ID: <540334B2.7000009@linux.intel.com>
Date: Sun, 31 Aug 2014 07:44:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, falcon@meizu.com, tiwai@suse.de,
        tj@kernel.org
CC: linux-kernel@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2014 2:03 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> While reviewing Wu Zhangjin's solution to async probe [0] and his
> ideas on creating async groups I decided to try following the init
> levels on the kernel to try to help with synchronization at least
> on some level. This borrows ideas discussed with the kthread_create()
> solution [1] and also simplifies the idea of how we should be grouping
> async calls between drivers.
>
> A few things worth mentioning. I decided to go down a generic solution as
> if we ever wanted to bring asynchrnonization behaviour below modules
> this would allow folks to start testing this without much effort. It
> allows asynchronous calls to upkeep the order already set in place
> for built-in code. If one wanted to eventually venture down below
> that path we'd need to add respective exit calls for each level, as
> right now we just assume that every level should use module_exit().
> SmPL grammer could be used to easily tidy this up, for example on
> the subsys_init():

before we added the current async approach the approach of async init calls was tried
At the time, Linus hated it and he was right, it was not the right thing.

What is different this time to make this the right thing to do ?


