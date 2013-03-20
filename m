Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3CTQAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab3CTP7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:59:46 -0400
Date: Wed, 20 Mar 2013 11:59:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
Message-ID: <20130320155942.GC2273@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
 <1363703941.2532.27.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363703941.2532.27.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:39:01AM -0400, Mimi Zohar wrote:

[..]
> 
> Lastly, adding 'VM_LOCKED' here seems to change existing, expected
> behavior.  According to the mlock(2) man pages, "Memory locks are not
> inherited by a child created via fork(2) and are automatically removed
> (unlocked) during an execve(2) or when the process terminates."  Someone
> else needs to comment on this sort of change.  Andrew?  Al?

I think removing locks during execve() makes sense. New executable will
get its own locked memory and it is not dependent on memory areas locked
before execve().

fork() is more interesting though. I guess we could just reset the
"signed" bit of forked process. So it does not inherit it from parent. And
when forked process does exec() it will lock its own memory areas and
get "signed" bit if signatuer verification was successful.

So looks like exeisting memory lock behavior on fork()/execve() will be
fine.

Thanks
Vivek
