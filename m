Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3EWILz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:11:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:41604 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3EWILw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:11:52 -0400
Message-ID: <519DCF36.80708@parallels.com>
Date: Thu, 23 May 2013 12:11:34 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <viro@zeniv.linux.org.uk>, <serge.hallyn@canonical.com>,
        <jlayton@redhat.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <bfields@fieldses.org>, <bharrosh@panasas.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
References: <20130522072840.27720.85023.stgit@localhost.localdomain> <878v36ex6n.fsf@xmission.com> <87wqqqdfqr.fsf@xmission.com>
In-Reply-To: <87wqqqdfqr.fsf@xmission.com>
Content-Type: text/plain; charset="windows-1251"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.05.2013 22:35, Eric W. Biederman пишет:
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> I am missing a lot of context here and capturing the context of a
>> process at time time we mount the filesystem and reconstituing it in
>> call user mode helper seems like something we could do.
>
> If we want to do something like this the only sane thing I can see is to
> have a per container version of kthread call it uthread.  That the user
> mode helper code would use to launch a new process.
>

The main point here, is that a container can have it's own root, different
to kthread's one (another mount or at least chroot result).

> Anything else and I expect we will be tearing our hair out for the rest
> of our lives with weird corner cases or unexpected semantics.
>
> At first glace I would exepct uthread to be per pid namespace in
> implementation.
>

Having a per-pidnamespace kernel thread would be really great.
But regrettably doesn't solve the root swapping problem.

> Eric
>
>


-- 
Best regards,
Stanislav Kinsbursky
