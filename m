Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbbAVIRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:17:10 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:61117 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAVIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:16:55 -0500
MIME-Version: 1.0
In-Reply-To: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 22 Jan 2015 09:16:34 +0100
X-Google-Sender-Auth: DrUYa_TgXY7baB-rEGb6j-K8RKk
Message-ID: <CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
Subject: Re: [PATCH v9 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com,
        bfoster@redhat.com, Namjae Jeon <namjae.jeon@samsung.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC += linux-api]

Hello Namjae

Please, all patches such as this that touch the user-space ABI must CC
linux-api@. (The kernel source file Documentation/SubmitChecklist
notes that all Linux kernel patches that change userspace interfaces
should be CCed to linux-api@vger.kernel.org.  See also
https://www.kernel.org/doc/man-pages/linux-api-ml.html )

Thanks,

Michael


On Wed, Jan 21, 2015 at 4:11 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> In continuation of the work of making the process of non linear editing of
> media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> for fallocate.
>
> This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
> by inserting a hole within the range specified by offset and len.
> User can write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len should
> be block size aligned for both XFS and Ext4.
>
> The semantics of the flag are :
> 1) It creates space within file by inserting a hole of  len bytes starting
>    at offset byte without overwriting any existing data. All the data blocks
>    from offset to EOF are shifted towards right to make hole space.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Insert range does not work for the case when offset is overlapping/beyond
>    i_size. If the user wants to insert space at the end of file they are
>    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> 5) It increses the size of file by len bytes.
>
>
> Namjae Jeon (11):
>  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
>  xfsprogs: xfs_io: add finsert command for insert range via fallocate
>  xfstests: generic/039: Standard insert range tests
>  xfstests: generic/040: Delayed allocation insert range
>  xfstests: generic/041: Multi insert range tests
>  xfstests: generic/042: Delayed allocation multi insert
>  xfstests: generic/043: Test multiple fallocate insert/collapse range calls
>  xfstests: fsstress: Add fallocate insert range operation
>  xfstests: fsx: Add fallocate insert range operation
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
