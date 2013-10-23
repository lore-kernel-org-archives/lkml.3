Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3JWKsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:48:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48187 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3JWKsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:48:13 -0400
MIME-Version: 1.0
In-Reply-To: <20131023124333.356d0e15@ipc1.ka-ro>
References: <20131023110618.7bd07899@ipc1.ka-ro>
	<20131023182609.6646b5c0@tom-ThinkPad-T410>
	<20131023124333.356d0e15@ipc1.ka-ro>
Date: Wed, 23 Oct 2013 18:48:06 +0800
Message-ID: <CACVXFVM0oUi0m8sGtRGX_VS6wouvo5=N7XN=s477290pzKKC2w@mail.gmail.com>
Subject: Re: userspace firmware load fails with current linux-next
From: Ming Lei <ming.lei@canonical.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 6:43 PM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:

> The patch as is produces a build error, because 'size' is only defined
> after the 'if' statement.

Sorry for that, :-)

>
> The modified patch below works for me.
>
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 5d818df..709d6f5 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -277,7 +277,7 @@ static ssize_t sysfs_write_file(struct file *file, const char __user *user_buf,
>         ssize_t len = min_t(size_t, count, PAGE_SIZE);
>         char *buf;
>
> -       if (sysfs_is_bin(of->sd)) {
> +       if (sysfs_is_bin(of->sd) && file_inode(file)->i_size) {
>                 loff_t size = file_inode(file)->i_size;
>
>                 if (size <= *ppos)

OK, thanks for your test, and will prepare a formal one later.


Thanks,
--
Ming Lei
