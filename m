Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaDRQYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaDRQYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:24:13 -0400
Date: Fri, 18 Apr 2014 18:23:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Chiang <pchiang@nvidia.com>
Cc: "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm : Avoid candidate task is equal to current task
Message-ID: <20140418162359.GA4398@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Peter Chiang wrote:
>
> It is a speculation where the panic was.
>
> [38261.652100] Call trace:
> [38261.654616] [<ffffffc000aa6fe0>] mm_update_next_owner+0x190/0x238
> [38261.660766] [<ffffffc000aa728c>] do_exit+0x204/0x924
> [38261.665790] [<ffffffc000aa7a1c>] do_group_exit+0x40/0xcc
> [38261.671169] [<ffffffc000ab59cc>] get_signal_to_deliver+0x218/0x57c
> [38261.677409] [<ffffffc000a87e6c>] do_signal+0x534/0x550
> [38261.682608] [<ffffffc000a88070>] do_notify_resume+0x20/0x58

Could you show the full dmesg?

Could you look into asm/objdump/addr2line to figure out what this
mm_update_next_owner+0x190 means?

Is it reproducable?

Hmm. I seem to see a bug in this function, it can be fulled by use_mm,
but I am not sure this can explain the problem. I'll send a patch.

Oleg.

