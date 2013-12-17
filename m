Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3LQPzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:55:22 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45549 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3LQPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:55:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120514164106.GB4439@redhat.com>
References: <20120514164106.GB4439@redhat.com>
Date: Tue, 17 Dec 2013 10:55:17 -0500
X-Google-Sender-Auth: W6z94WzQ-yp57z2uVf-SdLbZ0rw
Message-ID: <CA+5PVA6zz0b9V-YzzBLhJ+CktT+YsmxpAQZtXDr87D+69EnkUw@mail.gmail.com>
Subject: Re: Remove empty /proc/device-tree when no openfirmware exists.
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:41 PM, Dave Jones <davej@redhat.com> wrote:
> distribution kernels might want to build in support for /proc/device-tree
> for kernels that might end up running on hardware that doesn't support openfirmware.
> This results in an empty /proc/device-tree existing.
> Remove it if the OFW root node doesn't exist.
>
> [This situation actually confuses grub2, resulting in install failures.
>  grub2 sees the /proc/device-tree and picks the wrong install target
>  cf. http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/4300/util/grub-install.in#L311
>  grub should be more robust, but still, leaving an empty proc dir seems pointless. ]
>
> Signed-off-by: Dave Jones <davej@redhat.com>

We're still carrying this in Fedora for
https://bugzilla.redhat.com/show_bug.cgi?id=818378 .  Can we get this
upstream sometime soon?

josh

> diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> index 927cbd1..f060f28 100644
> --- a/fs/proc/proc_devtree.c
> +++ b/fs/proc/proc_devtree.c
> @@ -233,6 +233,7 @@ void __init proc_device_tree_init(void)
>                 return;
>         root = of_find_node_by_path("/");
>         if (root == NULL) {
> +               remove_proc_entry("device-tree", NULL);
>                 pr_debug("/proc/device-tree: can't find root\n");
>                 return;
>         }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
