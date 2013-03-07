Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3CGMzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:55:33 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53391 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3CGMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:55:32 -0500
MIME-Version: 1.0
In-Reply-To: <1362393975-22533-1-git-send-email-claudiu.ghioc@gmail.com>
References: <1362393975-22533-1-git-send-email-claudiu.ghioc@gmail.com>
Date: Thu, 7 Mar 2013 14:55:25 +0200
Message-ID: <CAEnQRZAiiJqHcEHoS+=ZMAHdQwu9yYc28or1Di7h4R7PRn6iEg@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: fix sparse warning for hugetlb_register_node
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Claudiu Ghioc <claudiughioc@gmail.com>, trivial@kernel.org,
        jkosina@suse.cz
Cc: akpm@linux-foundation.org, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Claudiu Ghioc <claudiu.ghioc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 12:46 PM, Claudiu Ghioc <claudiughioc@gmail.com> wrote:
> Removed the following sparse warnings:
> *  mm/hugetlb.c:1764:6: warning: symbol
>     'hugetlb_unregister_node' was not declared.
>     Should it be static?
> *   mm/hugetlb.c:1808:6: warning: symbol
>     'hugetlb_register_node' was not declared.
>     Should it be static?
>
> Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
> ---
>  mm/hugetlb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0a0be33..c65a8a5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1761,7 +1761,7 @@ static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
>   * Unregister hstate attributes from a single node device.
>   * No-op if no hstate attributes attached.
>   */
> -void hugetlb_unregister_node(struct node *node)
> +static void hugetlb_unregister_node(struct node *node)
>  {
>         struct hstate *h;
>         struct node_hstate *nhs = &node_hstates[node->dev.id];
> @@ -1805,7 +1805,7 @@ static void hugetlb_unregister_all_nodes(void)
>   * Register hstate attributes for a single node device.
>   * No-op if attributes already registered.
>   */
> -void hugetlb_register_node(struct node *node)
> +static void hugetlb_register_node(struct node *node)
>  {
>         struct hstate *h;
>         struct node_hstate *nhs = &node_hstates[node->dev.id];
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi Jiri,

Can you pick this up via trivial tree?

thanks,
Daniel.
