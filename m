Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaFKWWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:22:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:26131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaFKWWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:22:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,460,1400050800"; 
   d="scan'208";a="555981221"
Message-ID: <5398D691.7050202@intel.com>
Date: Wed, 11 Jun 2014 15:22:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Zhang Zhen <zhenzhang.zhang@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, laijs@cn.fujitsu.com,
        sjenning@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wang Nan <wangnan0@huawei.com>
Subject: Re: [patch] mm, hotplug: probe interface is available on several
 platforms
References: <53981D81.5060708@huawei.com> <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com> <alpine.DEB.2.02.1406111511450.27885@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406111511450.27885@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 03:15 PM, David Rientjes wrote:
> +CONFIG_ARCH_MEMORY_PROBE and can be configured on powerpc, sh, and x86
> +if hotplug is supported, although for x86 this should be handled by ACPI
> +notification.

Looks like a good change, in general.

My only nit is that this implies that all hotplug on x86 is ACPI-based,
which isn't true.  Xen, at least, has an extension to its ballooning
that does hotplugs without ACPI.
