Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaCMJOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:14:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22138 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaCMJOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:14:44 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6d-53217702c425
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>, "'Kim'" <jaegeuk.kim@samsung.com>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
References: <5319A2D5.6060201@cn.fujitsu.com>
In-reply-to: <5319A2D5.6060201@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 3/5] f2fs: format segment_info's show for better
	legibility
Date: Thu, 13 Mar 2014 17:13:38 +0800
Message-id: <001801cf3e9c$ac3330d0$04999270$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQD92v1OX0voUOasBE+TELEevx2Oe5yBSVcw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jQV3mcsVgg0lTWSyetx9gtri+6y+T
	xaVF7haXd81hc2Dx+H9wErPH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr40ffa+aC
	+aIVPXdXMDYw9gp0MXJySAiYSJzdNYEFwhaTuHBvPVsXIxeHkMB0RolpvzuYIZwfjBI9n7+w
	glSxCahILO/4zwRiiwh4Sty52MvYxcjBwSyQIrG8yxYkLCSgK7Fl03mwoZwCehIXJ3eD2cIC
	MRJrrl5nB7FZBFQlmn/tZwSxeQUsJVb09TJB2IISPybfA6tnFtCSWL/zOBOELS+xec1bZohD
	FSR2nH3NCHGCkcThpgaoenGJjUdusUxgFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBMfBMagfjygaLQ4wCHIxKPLwrlisEC7EmlhVX5h5ilOBgVhLhNS9Q
	DBbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAeNSUR61/
	2Wtu6awEd73LG6zXTBeekVW2P3b6RhmNsBms4on5Xy+t+rj6AJuJtL990todz37lt2p/X53g
	0cn9gWnZaaPA7RMtEhlr/x1P3qNQsuXDr+Y5sza9S125hkv7+Lufm98J3hMsj91WesvtdULk
	XeaZm5umzRbddDEhb0oMH1vy74nNgUosxRmJhlrMRcWJAPfDP219AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Friday, March 07, 2014 6:44 PM
> To: Kim
> Cc: linux-kernel; f2fs
> Subject: [f2fs-dev] [PATCH 3/5] f2fs: format segment_info's show for better legibility
> 
> The original segment_info's show is a bit out-of-format:
> 
> [root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
> 0 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0
> ......
> 0 0 0 0 0 0 0 0 0 0
> 0 0 1 0 0 1 [root@guz Demoes]#
> 
> so we fix it here for better legibility.
> [root@guz Demoes]# cat /proc/fs/f2fs/loop0/segment_info
> 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0
> 0 0 0 0 0 0 0 0 0 0
> ......
> 0 0 0 0 0 0 0 0 0 0
> 0 0 1 0 0 1
> [root@guz Demoes]#

Here is one case, this looks not legible.

0 0 0 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 509 512 512 512
512 512 512 512 512 512 512 512 512 512
512 512 512 512 331 278 0 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 512 512 512
512 512 512 512 512 512 512 512 512 512
0 512 512 512 512 512 512 1 0 512

So how about modifying code as following?

> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/super.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 72df734..6e4851c 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -546,11 +546,12 @@ static int segment_info_seq_show(struct seq_file *seq, void *offset)
> 
>  	for (i = 0; i < total_segs; i++) {
>  		seq_printf(seq, "%u", get_valid_blocks(sbi, i, 1));

		seq_printf(seq, "%-3u ", get_valid_blocks(sbi, i, 1));

> -		if (i != 0 && (i % 10) == 0)
> -			seq_puts(seq, "\n");
> +		if ((i % 10) == 9 || i == (total_segs - 1))
> +			seq_putc(seq, '\n');
>  		else
> -			seq_puts(seq, " ");
> +			seq_putc(seq, ' ');
>  	}
> +
>  	return 0;
>  }
> 
> --
> 1.7.7
> 
> 
> ------------------------------------------------------------------------------
> Subversion Kills Productivity. Get off Subversion & Make the Move to Perforce.
> With Perforce, you get hassle-free workflows. Merge that actually works.
> Faster operations. Version large binaries.  Built-in WAN optimization and the
> freedom to use Git, Perforce or both. Make the move to Perforce.
> http://pubads.g.doubleclick.net/gampad/clk?id=122218951&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

