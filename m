Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaCGOOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:14:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaCGOOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:14:53 -0500
Date: Fri, 7 Mar 2014 09:14:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: WANG Chao <chaowang@redhat.com>
Cc: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140307141413.GF1326@redhat.com>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 04:10:16PM +0800, WANG Chao wrote:

[..]
>  	}
>  
> -	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
> -					saved_max_pfn : max_pfn) * PAGE_SIZE);
> +	specified_table_size = determine_tce_table_size();

I don't think you can get rid of saved_max_pfn right away. What if
somebody is using old first kernel and new second kernel. Then old kernel
will still be using a table size which is smaller than 8M.

Thanks
Vivek
