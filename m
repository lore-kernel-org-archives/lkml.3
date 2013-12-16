Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3LPG6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:58:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3LPG63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:58:29 -0500
Date: Sun, 15 Dec 2013 23:00:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Message-Id: <20131215230004.97d14ce7.akpm@linux-foundation.org>
In-Reply-To: <201311201430.56135@pali>
References: <201311201430.56135@pali>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013 14:30:55 +0100 Pali Roh__r <pali.rohar@gmail.com> wrote:

> Both proc files are writeable and used for configuring cells. But
> there is missing correct mode flag for writeable files. Without
> this patch both proc files are read only.
> 
> diff --git a/fs/afs/proc.c b/fs/afs/proc.c
> index 526e4bb..276cb6e 100644
> --- a/fs/afs/proc.c
> +++ b/fs/afs/proc.c
> @@ -147,11 +147,11 @@ int afs_proc_init(void)
>  	if (!proc_afs)
>  		goto error_dir;
>  
> -	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
> +	p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
>  	if (!p)
>  		goto error_cells;
>  
> -	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
> +	p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
>  	if (!p)
>  		goto error_rootcell;

Please send a signed-off-by: for this, as per
Documentation/SubmittingPatches, section 12.

David ack?
