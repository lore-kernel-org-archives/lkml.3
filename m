Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaHZRDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:03:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48746 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaHZRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:03:17 -0400
X-IronPort-AV: E=Sophos;i="5.04,405,1406592000"; 
   d="scan'208";a="166075750"
Message-ID: <53FCBDD2.8040208@citrix.com>
Date: Tue, 26 Aug 2014 18:03:14 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/grant-table.c: Be sure of unsigned value
 never comparing with 0
References: <53FCAA04.40009@gmail.com>
In-Reply-To: <53FCAA04.40009@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 16:38, Chen Gang wrote:
> In grow_gnttab_list(), 'i' is 'unsigned int', and 'nr_glist_frames' may
> be 0 because 'nr_grant_frames' may be 0. So 'i' may never be less than
> 'nr_glist_frames' in failure processing, which cause infinite looping.

nr_grant_frames is at least 1.  See gnttab_init().

> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -592,8 +592,8 @@ static int grow_gnttab_list(unsigned int more_frames)
>  	return 0;
>  
>  grow_nomem:
> -	for ( ; i >= nr_glist_frames; i--)
> -		free_page((unsigned long) gnttab_list[i]);
> +	while (i > nr_glist_frames)
> +		free_page((unsigned long) gnttab_list[--i]);

while (i-- > nr_glist_frames)
    ...

Would have been better.

David
