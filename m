Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab3BLR0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:26:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:34419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab3BLR0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:26:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290161203"
Date: Tue, 12 Feb 2013 09:26:37 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 1/2] perf stat: refactor aggregation code
Message-ID: <20130212172637.GC30387@tassilo.jf.intel.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
 <1360678168-6974-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360678168-6974-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 03:09:27PM +0100, Stephane Eranian wrote:
> -		fmt = "%s%.0f%s%s";
> +		fmt = "%.0f%s%s";
>  	else if (big_num)
> -		fmt = "%s%'18.0f%s%-25s";
> +		fmt = "%'18.0f%s%-25s";
>  	else
> -		fmt = "%s%18.0f%s%-25s";
> +		fmt = "%18.0f%s%-25s";

I realize the code was like this before, but it's better to not 
use variable sprintf formats, as you lose all the compile
time checking of the compiler and mistakes in printf are common. 
Better to duplicate the sprintf.

The rest looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
