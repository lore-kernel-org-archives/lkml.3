Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab3FMPat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:30:49 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58703 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FMPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:30:45 -0400
MIME-Version: 1.0
In-Reply-To: <1361458226-8142-1-git-send-email-tim.gardner@canonical.com>
References: <20130221131931.GA29577@agk-dp.fab.redhat.com>
	<1361458226-8142-1-git-send-email-tim.gardner@canonical.com>
Date: Thu, 13 Jun 2013 18:30:45 +0300
Message-ID: <CA+ydwtq_THgL87ESb4Z4T8pMhZUQiAX_9qac2agPwHABGEjuRA@mail.gmail.com>
Subject: Re: [PATCH linux-next v2] DM RAID: validate_raid_redundancy: Silence
 uninitialized variable warning
From: Tommi Rantala <tt.rantala@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 Tim Gardner <tim.gardner@canonical.com>:
> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here

Hello, is this patch getting merged? I'm also seeing this exact same
compiler warning in my mainline builds.

Tommi

>
> It is impossible that rebuilds_per_group could be used before set, but set
> it to 0 anyways to silence GCC warnings.
>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>
> v2 - Added GCC comment. Update commit log with a more definite explanation.
>
> As Neil has pointed out, https://lwn.net/Articles/529954/ indicates
> uninitialized_var() is going away.
>
>  drivers/md/dm-raid.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 9d6bf19..1dbc341 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -380,7 +380,8 @@ static int validate_region_size(struct raid_set *rs, unsigned long region_size)
>  static int validate_raid_redundancy(struct raid_set *rs)
>  {
>         unsigned i, rebuild_cnt = 0;
> -       unsigned rebuilds_per_group, copies, d;
> +       unsigned rebuilds_per_group = 0; /* GCC 4.6.3 */
> +       unsigned copies, d;
>         unsigned group_size, last_group_start;
>
>         for (i = 0; i < rs->md.raid_disks; i++)
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
