Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaKPJC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:02:28 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:59383 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaKPJCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:02:24 -0500
Message-ID: <5468681C.5000307@electrozaur.com>
Date: Sun, 16 Nov 2014 11:02:20 +0200
From: Boaz Harrosh <ooo@electrozaur.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pieter Smith <pieter@boesman.nl>
CC: Benny Halevy <bhalevy@primarydata.com>,
        "open list:OSD LIBRARY and F..." <osd-dev@open-osd.org>,
        Josh Triplett <josh@joshtriplett.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 17/56] fs/exofs: support compiling out splice
References: <pieter@boesman.nl>	<1415913813-362-1-git-send-email-pieter@boesman.nl> <1415913813-362-18-git-send-email-pieter@boesman.nl>
In-Reply-To: <1415913813-362-18-git-send-email-pieter@boesman.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 11:22 PM, Pieter Smith wrote:
> Compile out splice support from exofs when the splice-family of syscalls is not
> supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>

ACK-by: Boaz Harrosh <ooo@electrozaur.com>

Or do you need that I push it through my tree ?
> ---
>  fs/exofs/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/file.c b/fs/exofs/file.c
> index 71bf8e4..23dfb05 100644
> --- a/fs/exofs/file.c
> +++ b/fs/exofs/file.c
> @@ -76,8 +76,8 @@ const struct file_operations exofs_file_operations = {
>  	.release	= exofs_release_file,
>  	.fsync		= exofs_file_fsync,
>  	.flush		= exofs_flush,
> -	.splice_read	= generic_file_splice_read,
> -	.splice_write	= iter_file_splice_write,
> +	SPLICE_READ_INIT(generic_file_splice_read)
> +	SPLICE_WRITE_INIT(iter_file_splice_write)
>  };
>  
>  const struct inode_operations exofs_file_inode_operations = {
> 

