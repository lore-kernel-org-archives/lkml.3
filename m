Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901Ab3DDPnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:43:00 -0400
Received: from relay2.sgi.com ([192.48.179.30]:59574 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761680Ab3DDPm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:42:57 -0400
Message-ID: <515D9F8A.2060505@sgi.com>
Date: Thu, 4 Apr 2013 10:43:06 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the akpm tree with the vfs tree
References: <20130404172648.27834d12cbb68338f4b89482@canb.auug.org.au> <20130403235634.6bc72c39.akpm@linux-foundation.org> <20130404080248.GN21522@ZenIV.linux.org.uk>
In-Reply-To: <20130404080248.GN21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 03:02 AM, Al Viro wrote:
> On Wed, Apr 03, 2013 at 11:56:34PM -0700, Andrew Morton wrote:
>> On Thu, 4 Apr 2013 17:26:48 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>>> Hi Andrew,
>>>
>>> Today's linux-next merge of the akpm tree got a conflict in
>>> fs/proc/generic.c between several commits from the vfs tree and commit
>>> "procfs: improve scaling in proc" from the akpm tree.
>>>
>>> I just dropped the akpm tree patch (and the following
>>> "procfs-improve-scaling-in-proc-v5") as the conflicts are a bit complex.
>> Well perhaps the vfs tree should start paying some attention to the
>> rest of the world, particularly after -rc5.
> I'm sorry, but... not in this case.  There are seriously nasty races around
> remove_proc_entry()/proc_reg_release() and the whole area needs a rewrite.
> Tentative fix is in vfs.git#experimental; I hadn't pushed it into #for-next
> yet, but Nathan's patches are definitely going to buggered by any realistic
> solution.
In this case I will resubmit my first patch for moving the kfree in 
proc_reg_release.

