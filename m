Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbbANPmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:42:15 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60363 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbbANPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:42:13 -0500
Date: Wed, 14 Jan 2015 16:42:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: fold move_anon() and move_file()
Message-ID: <20150114154210.GG4706@dhcp22.suse.cz>
References: <1421175592-14179-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421175592-14179-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-01-15 13:59:52, Johannes Weiner wrote:
> Turn the move type enum into flags and give the flags field a shorter
> name.  Once that is done, move_anon() and move_file() are simple
> enough to just fold them into the callsites.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

one nit below

> ---
>  mm/memcontrol.c | 49 ++++++++++++++++++-------------------------------
>  1 file changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5a5769e8b12c..692e96407627 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -360,21 +360,18 @@ static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
>  
>  /* Stuffs for move charges at task migration. */
>  /*
> - * Types of charges to be moved. "move_charge_at_immitgrate" and
> - * "immigrate_flags" are treated as a left-shifted bitmap of these types.
> + * Types of charges to be moved.
>   */
> -enum move_type {
> -	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
> -	MOVE_CHARGE_TYPE_FILE,	/* file page(including tmpfs) and swap of it */
> -	NR_MOVE_TYPE,
> -};
> +#define MOVE_ANON	0x1U
> +#define MOVE_FILE	0x2U
> +#define MOVE_MASK	0x3U

#define MOVE_MASK	(MOVE_ANON | MOVE_FILE)

would be probably better
[...]
-- 
Michal Hocko
SUSE Labs
