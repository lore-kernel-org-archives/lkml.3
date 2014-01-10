Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbaAJVMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaAJVMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:12:21 -0500
Date: Fri, 10 Jan 2014 16:12:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, kosaki.motohiro@gmail.com,
        dyoung@redhat.com, linux-acpi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory
 mapping is specified by user [v2]
Message-ID: <20140110211204.GC19115@redhat.com>
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>
 <1389380698-19361-4-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389380698-19361-4-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 02:04:58PM -0500, Prarit Bhargava wrote:

> kdump uses memmap=exactmap and mem=X values

Minor nit. Kdump only uses memmap=exactmap and not mem=X. mem=X is there
for debugging. So lets fix the changelog.

[..]
>  static int __init parse_memmap_opt(char *str)
>  {
> +	int ret;
> +
>  	while (str) {
>  		char *k = strchr(str, ',');
>  
>  		if (k)
>  			*k++ = 0;
>  
> -		parse_memmap_one(str);
> +		ret = parse_memmap_one(str);
> +		if (!ret)
> +			set_acpi_no_memhotplug();

We want to call this only in case of memmap=exactmap and not other memmap=
options. So I think instead of here, call it inside parse_memmap_one()
where exactmap check is done.

        if (!strncmp(p, "exactmap", 8)) {
		set_acpi_no_memhotplug();
	}

Thanks
Vivek
