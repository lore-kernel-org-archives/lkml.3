Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaEMSwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:52:39 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:47710 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbaEMSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140513193033.39a92e627c49f4bdcbbf0a62@skynet.be>
References: <20140513193033.39a92e627c49f4bdcbbf0a62@skynet.be>
From: Steve French <smfrench@gmail.com>
Date: Tue, 13 May 2014 20:52:10 +0200
Message-ID: <CAH2r5mtW+d9D7WyGhj_SG-dhBXDo6C9rSub=J9F8KJM-aRyKXQ@mail.gmail.com>
Subject: Re: [PATCH V2] fs/cifs/netmisc.c: convert printk to pr_foo()
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Tue, May 13, 2014 at 7:30 PM, Fabian Frederick <fabf@skynet.be> wrote:
> Also fixes array checkpatch warning and converts it to static const
> (suggested by Joe Perches).
>
> Cc: Joe Perches <joe@perches.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> v2: static const array (suggested by Joe Perches)
>
>  fs/cifs/netmisc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 0498845..6834b9c 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -795,8 +795,8 @@ cifs_print_status(__u32 status_code)
>         while (nt_errs[idx].nt_errstr != NULL) {
>                 if (((nt_errs[idx].nt_errcode) & 0xFFFFFF) ==
>                     (status_code & 0xFFFFFF)) {
> -                       printk(KERN_NOTICE "Status code returned 0x%08x %s\n",
> -                                  status_code, nt_errs[idx].nt_errstr);
> +                       pr_notice("Status code returned 0x%08x %s\n",
> +                                 status_code, nt_errs[idx].nt_errstr);
>                 }
>                 idx++;
>         }
> @@ -941,8 +941,9 @@ cifs_UnixTimeToNT(struct timespec t)
>         return (u64) t.tv_sec * 10000000 + t.tv_nsec/100 + NTFS_TIME_OFFSET;
>  }
>
> -static int total_days_of_prev_months[] =
> -{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
> +static const int total_days_of_prev_months[] = {
> +       0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334
> +};
>
>  struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
>  {
> --
> 1.8.4.5
>



-- 
Thanks,

Steve
