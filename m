Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3KIPTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:19:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33642 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3KIPTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:19:33 -0500
MIME-Version: 1.0
In-Reply-To: <1383963966-10888-1-git-send-email-liwang@ubuntukylin.com>
References: <1383963966-10888-1-git-send-email-liwang@ubuntukylin.com>
Date: Sat, 9 Nov 2013 10:19:31 -0500
Message-ID: <CANP1eJHthD-Q_Xv=HPWQjsJTHvpP2fj-X_j7HgBXaz5YKQ2EAQ@mail.gmail.com>
Subject: Re: [PATCH] Ceph: allocate non-zero page to fscache in readpage()
From: Milosz Tanski <milosz@adfin.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li, that's a good good catch.


On Fri, Nov 8, 2013 at 9:26 PM, Li Wang <liwang@ubuntukylin.com> wrote:
> ceph_osdc_readpages() returns number of bytes read, currently,
> the code only allocate full-zero page into fscache, this patch
> fixes this.
>
> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
> ---
>  fs/ceph/addr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6df8bd4..1e561c0 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -216,7 +216,7 @@ static int readpage_nounlock(struct file *filp, struct page *page)
>         }
>         SetPageUptodate(page);
>
> -       if (err == 0)
> +       if (err >= 0)
>                 ceph_readpage_to_fscache(inode, page);
>
>  out:
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com
