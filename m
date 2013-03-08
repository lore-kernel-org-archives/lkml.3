Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3CHIRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:17:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab3CHIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:17:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,807,1355068800"; 
   d="scan'208";a="6836548"
Message-ID: <51399F34.2030500@cn.fujitsu.com>
Date: Fri, 08 Mar 2013 16:20:04 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 14/14] x86, mm: Put pagetable on local node ram
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org> <1362718720-27048-15-git-send-email-yinghai@kernel.org>
In-Reply-To: <1362718720-27048-15-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/08 16:16:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/08 16:16:31,
	Serialize complete at 2013/03/08 16:16:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On 03/08/2013 12:58 PM, Yinghai Lu wrote:
......
>   	/* xen has big range in reserved near end of ram, skip it at first.*/
> -	addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
> +	addr = memblock_find_in_range(begin, end, PMD_SIZE, PMD_SIZE);

Found that the latest code here is:

  414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE,
  415                          PAGE_SIZE);
                              ^^^^^^^^^^^^

The "align" is PAGE_SIZE, not PMD_SIZE. Not sure if it is a problem. :)

Thanks. :)


