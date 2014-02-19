Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaBSW40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:56:26 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:35940 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaBSW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140219215805.GA1714@gmail.com>
References: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
	<20140219215805.GA1714@gmail.com>
Date: Thu, 20 Feb 2014 07:56:21 +0900
Message-ID: <CAKYAXd_OhFBAt39Wf5XnOY4VhcNtQPCEV-OMYQcUd8j+LbF=9g@mail.gmail.com>
Subject: Re: [PATCH v5 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-20 6:58 GMT+09:00, Dongsu Park <dongsu.park@profitbricks.com>:
> Hi Namjae,
> see below:
Hi Dongsu.
>
> On 19.02.2014 01:38, Namjae Jeon wrote:
>> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
> ...<snip>...
>> +	/*
>> +	 * Don't start shifting extents until we make sure the hole is big
>> +	 * enough to accomodate the shift.
>> +	 */
>> +	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
>> +	depth = path->p_depth;
>> +	extent =  path[depth].p_ext;
>> +	ex_start = extent->ee_block;
>> +	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
>> +	ext4_ext_drop_refs(path);
>> +	kfree(path);
>> +
>> +	if ((start == ex_start && shift > ex_start) ||
>> +	    (shift > start - ex_end)) {
>
> This line causes a compile error. So the fix would be like that:
Oops.. I made a stupid mistake when creating the patch at dawn..
Thanks for your pointing.
>
> -	    (shift > start - ex_end)) {
> +	    (shift > start - ex_end))
>
>> +		return -EINVAL;
>> +
>> +	/* Its safe to start updating extents */
Yes, Right.
> ...<snip>...
>
> Apart from that, the whole patchset seems to work without error,
> both on xfs and on ext4.
> Of course I had to remove Lukas' patches before testing collapse-range.
> So it would be excellent if two patch series could get somehow merged.
>
> Tested-by: Dongsu Park <dongsu.park@profitbricks.com>
Thank you so much for your testing!
>
> Regards,
> Dongsu
>
