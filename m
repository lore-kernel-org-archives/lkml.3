Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3IXL1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 07:27:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:49657 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3IXL1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 07:27:07 -0400
Message-ID: <524176BD.9060403@imgtec.com>
Date: Tue, 24 Sep 2013 12:25:49 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] sysfs: Allow mounting without CONFIG_NET
References: <878uzmhkqg.fsf@xmission.com> <874naahkng.fsf@xmission.com> <524018EA.9070202@imgtec.com> <87ioxrrzb6.fsf_-_@tw-ebiederman.twitter.com>
In-Reply-To: <87ioxrrzb6.fsf_-_@tw-ebiederman.twitter.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_24_12_27_03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/13 22:41, Eric W. Biederman wrote:
> 
> In kobj_ns_current_may_mount the default should be to allow the
> mount.  The test is only for a single kobj_ns_type at a time, and unless
> there is a reason to prevent it the mounting sysfs should be allowed.
> Subsystems that are not registered can't have are not involved so can't
> have a reason to prevent mounting sysfs.
> 
> This is a bug-fix to:
>     commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e
>     Author: Eric W. Biederman <ebiederm@xmission.com>
>     Date:   Mon Mar 25 20:07:01 2013 -0700
>     
>         sysfs: Restrict mounting sysfs
>         
>         Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
>         over the net namespace.  The principle here is if you create or have
>         capabilities over it you can mount it, otherwise you get to live with
>         what other people have mounted.
>         
>         Instead of testing this with a straight forward ns_capable call,
>         perform this check the long and torturous way with kobject helpers,
>         this keeps direct knowledge of namespaces out of sysfs, and preserves
>         the existing sysfs abstractions.
>         
>         Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>         Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> That came in via the userns tree during the 3.12 merge window.
>     
> Reported-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Tested-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

