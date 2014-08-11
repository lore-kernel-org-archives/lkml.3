Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaHKMF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:05:59 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:60567 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaHKMF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:05:57 -0400
Message-ID: <1407758751.4246.134.camel@xylophone>
Subject: Re: [Linux-kernel] [PATCH] seq_file: Document seq_open_private(),
 seq_release_private()
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, swhiteho@redhat.com, viro@ZenIV.linux.org.uk
Date: Mon, 11 Aug 2014 13:05:51 +0100
In-Reply-To: <1407423064-30816-1-git-send-email-rob.jones@codethink.co.uk>
References: <1407423064-30816-1-git-send-email-rob.jones@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 15:51 +0100, Rob Jones wrote:
> Despite the fact that these functions have been around for years, they are
> little used (only 15 uses in 13 files at the preseht time) even though
> many other files use work-arounds to achieve the same result.
> 
> By documenting them, hopefully they will become more widely used.
> 
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>  Documentation/filesystems/seq_file.txt |   33 ++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
> index a1e2e0d..c9b8f6b 100644
> --- a/Documentation/filesystems/seq_file.txt
> +++ b/Documentation/filesystems/seq_file.txt
> @@ -226,6 +226,39 @@ be used for more than one file, you can store an arbitrary pointer in the
>  private field of the seq_file structure; that value can then be retrieved
>  by the iterator functions.
>  
> +There is also a wrapper function to seq_open(), seq_open_private(). It
> +kmallocs a zero filled block of memory and stores a pointer to it in the
> +private field of the seq_file structure, returning 0 on success. The
> +block size is specified in a third parameter to the function, e.g.:
> +
> +	static int ct_open(struct inode *inode, struct file *file)
> +	{
> +		return seq_open_private(file, &ct_seq_ops,
> +					sizeof(struct mystruct);

Missing close-parenthesis.

> +	}
> +
> +There is also a variant function, __seq_open_private(), which is functionally
> +identical except that, if successful, it returns the pointer to the allocated
> +memory block, allowing further initialisation e.g.:
> +
> +	static int ct_open(struct inode *inode, struct file *file)
> +	{
> +		struct mystruct *p =
> +			__seq_open_private(file, &ct_seq_ops, sizeof(*p);
[...]

and here.

Ben.


