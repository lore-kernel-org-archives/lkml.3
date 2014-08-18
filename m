Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaHRLu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaHRLuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:50:25 -0400
Message-ID: <53F1E879.2050302@redhat.com>
Date: Mon, 18 Aug 2014 12:50:17 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rob Jones <rob.jones@codethink.co.uk>, linux-fsdevel@vger.kernel.org
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, viro@ZenIV.linux.org.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk
Subject: Re: [PATCH V3] seq_file: Document seq_open_private(), seq_release_private()
References: <1408362005-21504-1-git-send-email-rob.jones@codethink.co.uk>
In-Reply-To: <1408362005-21504-1-git-send-email-rob.jones@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18/08/14 12:40, Rob Jones wrote:
> Despite the fact that these functions have been around for years, they are
> little used (only 15 uses in 13 files at the preseht time) even though
> many other files use work-arounds to achieve the same result.
>
> By documenting them, hopefully they will become more widely used.
>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

> ---
>   Documentation/filesystems/seq_file.txt |   33 ++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
>
> diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
> index a1e2e0d..420fc0d 100644
> --- a/Documentation/filesystems/seq_file.txt
> +++ b/Documentation/filesystems/seq_file.txt
> @@ -226,6 +226,39 @@ be used for more than one file, you can store an arbitrary pointer in the
>   private field of the seq_file structure; that value can then be retrieved
>   by the iterator functions.
>   
> +There is also a wrapper function to seq_open() called seq_open_private(). It
> +kmallocs a zero filled block of memory and stores a pointer to it in the
> +private field of the seq_file structure, returning 0 on success. The
> +block size is specified in a third parameter to the function, e.g.:
> +
> +	static int ct_open(struct inode *inode, struct file *file)
> +	{
> +		return seq_open_private(file, &ct_seq_ops,
> +					sizeof(struct mystruct));
> +	}
> +
> +There is also a variant function, __seq_open_private(), which is functionally
> +identical except that, if successful, it returns the pointer to the allocated
> +memory block, allowing further initialisation e.g.:
> +
> +	static int ct_open(struct inode *inode, struct file *file)
> +	{
> +		struct mystruct *p =
> +			__seq_open_private(file, &ct_seq_ops, sizeof(*p));
> +
> +		if (!p)
> +			return -ENOMEM;
> +
> +		p->foo = bar; /* initialize my stuff */
> +			...
> +		p->baz = true;
> +
> +		return 0;
> +	}
> +
> +A corresponding close function, seq_release_private() is available which
> +frees the memory allocated in the corresponding open.
> +
>   The other operations of interest - read(), llseek(), and release() - are
>   all implemented by the seq_file code itself. So a virtual file's
>   file_operations structure will look like:

