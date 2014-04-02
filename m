Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaDBSAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:00:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43622 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaDBSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:00:43 -0400
Message-ID: <533C503B.7000007@oracle.com>
Date: Wed, 02 Apr 2014 13:00:27 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, jfs-discussion@lists.sourceforge.net
Subject: Re: [Jfs-discussion] [PATCH 1/1] fs/jfs/jfs_inode.c: atomically set
 inode->i_flags
References: <20140402192950.82812a331cb154bbc0a4183c@skynet.be> <20140402174707.GK6901@thunk.org>
In-Reply-To: <20140402174707.GK6901@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 12:47 PM, Theodore Ts'o wrote:
> On Wed, Apr 02, 2014 at 07:29:50PM +0200, Fabian Frederick wrote:
>> +	set_mask_bits(&inode->i_flags, S_IMMUTABLE | S_APPEND | S_NOATIME |
>> +				       S_DIRSYNC | S_SYNC, new_fl);
> 
> Warning --- per discussion with Linus over the weekend, he decided he
> really didn't like the set_mask_bits() interface, because it was too
> prone to abuse.  Unfortuantely, Linus had already included an earlier
> version of my patch that used set_mask_bits() in 3.14 without letting
> me know.  This is what I have in my ext4 tree for the merge window,
> which is undergoing final testing at the moment.  This will cause a
> patch conflict, and it's likely (given Linus's dislike of the
> set_mask_bits interface) that set_mask_bits() will end up getting
> removed from the tree, if not when he fixes up the merge conflict, but
> subsequent to -rc1.

Thanks Ted. I'll wait until the ext4 piece is resolved before merging
this one.

Fabian, feel free to resubmit the patch based on Ted's revision.
Otherwise, I'll fix it up myself.

Thanks,
Shaggy
