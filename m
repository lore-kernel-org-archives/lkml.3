Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaCRNEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:04:25 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:41221 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaCRNDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:03:12 -0400
Message-ID: <53283DFB.6040105@gmail.com>
Date: Tue, 18 Mar 2014 13:37:15 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.de>
CC: mtk.manpages@gmail.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: For review: open_by_name_at(2) man page
References: <53271B69.3000305@gmail.com> <20140318090007.3adee3d0@notabene.brown> <20140318094321.GA17024@infradead.org>
In-Reply-To: <20140318094321.GA17024@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:43 AM, Christoph Hellwig wrote:
> On Tue, Mar 18, 2014 at 09:00:07AM +1100, NeilBrown wrote:
>> ESTALE is also returned if the filesystem does not support file-handle ->
>> file mappings.
>> On filesystems which don't provide export_operations (/sys /proc ubifs
>> romfs cramfs nfs coda ... several others) name_to_handle_at will produce a
>> generic handle using the 32 bit inode and 32 bit i_generation.
> 
> Do we?  Seems like the code is erroring out early if there are no
> export_ops?

It appears to me that Neil's statement isn't correct, at least for /proc
and /sys (see my other mail, to Neil). I'm unsure about whether it is true
for some of those other FSes thought.

>> Does it?  My understanding from "man libblkid" (it is a while since I've read
>> the code) is that it either uses info in /dev/disks/by-* or reads directly
>> from the block devices (maybe using /sys to find them?) and interprets the
>> superblock to extract a UUID.
> 
> It normally reads directly from disk, unless it has changed very
> recently.

Thanks. As noted in my mail, I solved this one by just saying a little less
about libblkid.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
