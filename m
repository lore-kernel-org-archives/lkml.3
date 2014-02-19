Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaBSV6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:58:19 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34140 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaBSV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:58:14 -0500
Date: Wed, 19 Feb 2014 22:58:05 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH v5 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE for
 fallocate
Message-ID: <20140219215805.GA1714@gmail.com>
References: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392741489-20097-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,
see below:

On 19.02.2014 01:38, Namjae Jeon wrote:
> This patch implements fallocate's FALLOC_FL_COLLAPSE_RANGE for Ext4.
...<snip>...
> +	/*
> +	 * Don't start shifting extents until we make sure the hole is big
> +	 * enough to accomodate the shift.
> +	 */
> +	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
> +	depth = path->p_depth;
> +	extent =  path[depth].p_ext;
> +	ex_start = extent->ee_block;
> +	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
> +	ext4_ext_drop_refs(path);
> +	kfree(path);
> +
> +	if ((start == ex_start && shift > ex_start) ||
> +	    (shift > start - ex_end)) {

This line causes a compile error. So the fix would be like that:

-	    (shift > start - ex_end)) {
+	    (shift > start - ex_end))

> +		return -EINVAL;
> +
> +	/* Its safe to start updating extents */
...<snip>...

Apart from that, the whole patchset seems to work without error,
both on xfs and on ext4.
Of course I had to remove Lukas' patches before testing collapse-range.
So it would be excellent if two patch series could get somehow merged.

Tested-by: Dongsu Park <dongsu.park@profitbricks.com>

Regards,
Dongsu
