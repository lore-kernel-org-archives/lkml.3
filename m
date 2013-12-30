Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3L3Gqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:46:53 -0500
Received: from alt-proxy31.mail.unifiedlayer.com ([74.220.221.129]:57381 "HELO
	alt-proxy31.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751230Ab3L3Gqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:46:52 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Dec 2013 01:46:52 EST
Message-ID: <1388385607.3988.14.camel@slavad-ubuntu>
Subject: Re: [PATCH] fs/nilfs2: Integer overflow in nilfs_ioctl_wrap_copy()
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Reply-To: slava@dubeyko.com
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Dec 2013 10:40:07 +0400
In-Reply-To: <1388197696-4648-1-git-send-email-fanwlexca@gmail.com>
References: <1388197696-4648-1-git-send-email-fanwlexca@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 109.188.127.172 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2013-12-28 at 10:28 +0800, Wenliang Fan wrote:
> The local variable 'pos' comes from userspace. If a large number was
> passed, there would be an integer overflow in the following line:
>         pos += n;
> 
> Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
> ---
>  fs/nilfs2/ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> index b44bdb2..a260a98 100644
> --- a/fs/nilfs2/ioctl.c
> +++ b/fs/nilfs2/ioctl.c
> @@ -65,6 +65,8 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>  	ret = 0;
>  	total = 0;
>  	pos = argv->v_index;
> +	if (pos > ULONG_MAX - argv->v_nmembs)
> +		return -EINVAL;

I am slightly confused. Does this patch means that you refused previous
one? Or this patch is addition to the previous one?

You need to prepare next version of the patch or to prepare patch set
from two patches. And it makes sense to provide changelog of your work,
I think.

Thanks,
Vyacheslav Dubeyko.

>  	for (i = 0; i < argv->v_nmembs; i += n) {
>  		n = (argv->v_nmembs - i < maxmembs) ?
>  			argv->v_nmembs - i : maxmembs;


