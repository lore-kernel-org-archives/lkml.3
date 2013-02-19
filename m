Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab3BSD3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:29:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758115Ab3BSD3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:29:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,692,1355068800"; 
   d="scan'208";a="6727121"
Message-ID: <5122F17C.6020209@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 11:29:00 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [bug]patch "acpi, memory-hotplug: parse SRAT before memblock
 is ready" breaks numa detection
References: <20130219030752.GA30739@kernel.org>
In-Reply-To: <20130219030752.GA30739@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 11:28:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 11:28:59,
	Serialize complete at 2013/02/19 11:28:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:07 AM, Shaohua Li wrote:
> This patch in linux-next breaks numa detection. numa_init() will zero
> numa_meminfo. If acpi_numa_init() does not call early_parse_srat(), we will
> have no memory numa info.
>

Hum, yes, I missed this one. :)

Briefly seeing the code, I think moving the following code to 
early_parse_srat()
will fix it, right? :)

	memset(&numa_meminfo, 0, sizeof(numa_meminfo));

I'll send a patch to fix it.

Thanks. :)
