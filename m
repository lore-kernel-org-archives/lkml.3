Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaCESeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 13:34:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54467 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaCESep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 13:34:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
References: <74f5a436ebf5c13ed89a81c47ba09a6549e385f6.1394035568.git.richardcochran@gmail.com>
	<20140305183042.GC9824@kroah.com>
Date: Wed, 05 Mar 2014 10:34:38 -0800
In-Reply-To: <20140305183042.GC9824@kroah.com> (Greg Kroah-Hartman's message
	of "Wed, 5 Mar 2014 10:30:42 -0800")
Message-ID: <87k3c8ze81.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+waJAhddAiUZ7VSMCxpnpKFZ5nplzIJjA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernfs: fix off by one error.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Mar 05, 2014 at 05:10:52PM +0100, Richard Cochran wrote:
>> The hash values 0 and 1 are reserved for magic directory entries, but
>> the code only prevents names hashing to 0. This patch fixes the test
>> to also prevent hash value 1.
>> 
>> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>  fs/kernfs/dir.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Is this for 3.14-final or 3.15-rc1?

The bug has existed since I added that hash function in 3.4-rc1.  It was
named sysfs_name_hash then but the code has otherwise been unchanged.

It is a very minor bug.

commit 4e4d6d860b9393c5395ba5920edb5b4c5d43a3a3
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Dec 18 20:05:43 2011 -0800

    sysfs: Add s_hash to sysfs_dirent and order directory entries by hash
    
    Compute a 31 bit hash of directory entries (that can fit in a signed
    32bit off_t) and index the sysfs directory entries by that hash,
    replacing the per directory indexes by name and by inode.  Because we
    now only use a single rbtree this reduces the size of sysfs_dirent by 2
    pointers.  Because we have fewer cases to deal with the code is now
    simpler.
    
    For now I use the simple hash that the dcache uses as that is easy to
    use and seems simple enough.
    
    In addition to makeing the code simpler using a hash for the file
    position in readdir brings sysfs in line with other filesystems that
    have non-trivial directory structures.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Eric

