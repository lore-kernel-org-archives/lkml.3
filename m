Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694Ab3D3Nhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:37:37 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:56778 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759102Ab3D3Nhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:37:36 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 09:37:36 EDT
Date: Tue, 30 Apr 2013 13:32:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tim Chen <tim.c.chen@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] Make the batch size of the percpu_counter
 configurable
In-Reply-To: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
Message-ID: <0000013e5b24d2c5-9b899862-e2fd-4413-8094-4f1e5a0c0f62-000000@email.amazonses.com>
References: <c1f9c476a8bd1f5e7049b8ac79af48be61afd8f3.1367254913.git.tim.c.chen@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.30-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Tim Chen wrote:

> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index d5dd465..5ca7df5 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -22,6 +22,7 @@ struct percpu_counter {
>  	struct list_head list;	/* All percpu_counters are on a list */
>  #endif
>  	s32 __percpu *counters;
> +	int *batch ____cacheline_aligned_in_smp;
>  };

What is this for and why does it have that alignmend?
