Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaLULKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:10:22 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52091 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLULKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:10:20 -0500
MIME-Version: 1.0
In-Reply-To: <1419159379-11407-1-git-send-email-geert@linux-m68k.org>
References: <1419159379-11407-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 21 Dec 2014 14:10:19 +0300
Message-ID: <CALFYKtBacSpF0+35gGhAcWe4PKS3-nRXhy98UivBLX2m_vBmwg@mail.gmail.com>
Subject: Re: [PATCH] ceph: Use %zu to format size_t in ceph_fill_inline_data()
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sage Weil <sage@inktank.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 1:56 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On 32-bit, where size_t is unsigned int:
>
> fs/ceph/addr.c: In function ‘ceph_fill_inline_data’:
> fs/ceph/addr.c:1419: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 10 has type ‘size_t’
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index f5013d92a7e6b73d..c81c0e004588b9e2 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1416,7 +1416,7 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>                 }
>         }
>
> -       dout("fill_inline_data %p %llx.%llx len %lu locked_page %p\n",
> +       dout("fill_inline_data %p %llx.%llx len %zu locked_page %p\n",
>              inode, ceph_vinop(inode), len, locked_page);

Sorry, it's been reported by kbuild robot a couple days ago and is
already fixed along with another warning.

Thanks,

                Ilya
