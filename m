Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbaJaVuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:50:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:35509 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881AbaJaVuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:50:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="614983994"
Message-ID: <54540412.4000405@linux.intel.com>
Date: Fri, 31 Oct 2014 14:50:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: dave.hansen@linux.intel.com, x86@kernel.org, qiaowei.ren@intel.com,
        fenghua.yu@intel.com
Subject: Re: [RFC][PATCH] x86 mpx: give bndX registers actual names
References: <20141031212237.30B94E08@viggo.jf.intel.com>
In-Reply-To: <20141031212237.30B94E08@viggo.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 02:22 PM, Dave Hansen wrote:
>  
> -struct bndregs_struct {
> -	u64 bndregs[8];
> +struct bndreg_struct {
> +	u64 lb; /* lower bound */
> +	u64 ub; /* upper bound */
>  } __packed;
>  
>  struct bndcsr_struct {
> @@ -394,7 +395,7 @@ struct xsave_struct {
>  	struct xsave_hdr_struct xsave_hdr;
>  	struct ymmh_struct ymmh;
>  	struct lwp_struct lwp;
> -	struct bndregs_struct bndregs;
> +	struct bndreg_struct bnd[4];
>  	struct bndcsr_struct bndcsr;
>  	/* new processor state extensions will go here */
>  } __attribute__ ((packed, aligned (64)));
> _
> 

How about "struct bndreg"?

	-hpa

