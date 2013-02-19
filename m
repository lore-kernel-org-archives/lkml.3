Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3BSCxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:53:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19283 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3BSCxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:53:46 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Kj4EzYV-Q1YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=UBABGCGrqOkA:10 a=hD80L64hAAAA:8 a=yo55gvePGu3n3PxAc7AA:9 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361242425.23152.190.camel@gandalf.local.home>
Subject: Re: [PATCH 4/8] f2fs: add tracepoint for tracing the page i/o
 operations
From: Steven Rostedt <rostedt@goodmis.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Mon, 18 Feb 2013 21:53:45 -0500
In-Reply-To: <1361241215-18141-1-git-send-email-linkinjeon@gmail.com>
References: <1361241215-18141-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 11:33 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 

I see you already took my advice in patch 3, but here's another one that
could be fixed.

-- Steve

> +TRACE_EVENT(f2fs_get_data_block_exit,
> +	TP_PROTO(struct inode *inode, int ret),
> +
> +	TP_ARGS(inode, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(int,	ret)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->ret	= ret;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu return value %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino, __entry->ret)
> +);
> +
>  #endif /* _TRACE_F2FS_H */
>  
>   /* This part must be outside protection */


