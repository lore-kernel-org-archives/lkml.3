Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaCZAYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:24:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:56067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbaCZAY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:24:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,732,1389772800"; 
   d="scan'208";a="480016547"
Message-ID: <53321E3B.8080709@linux.intel.com>
Date: Tue, 25 Mar 2014 17:24:27 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, dborkman@redhat.com
CC: ast@plumgrid.com, netdev@vger.kernel.org, hagen@jauu.net,
        keescook@chromium.org, pmoore@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 8/9] net: filter: rework/optimize internal
 BPF interpreter's instruction set
References: <1395749457-16178-1-git-send-email-dborkman@redhat.com>	<1395749457-16178-9-git-send-email-dborkman@redhat.com> <20140325.201712.1651156258234145348.davem@davemloft.net>
In-Reply-To: <20140325.201712.1651156258234145348.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 05:17 PM, David Miller wrote:
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Tue, 25 Mar 2014 13:10:56 +0100
> 
>>   - Conditional jt/jf targets replaced with jt/fall-through,
>>     and forward/backward jumps now possible as well
> 
> Ummm... does anyone even remember why backwards jumps were not allowed
> in the original BPF?
> 
> It's to guarentee forward progress in the filter.
> 
> Allowing branching backward would allow endless loops.
> 
> Please remove this feature.
> 

If you allow loops, it greatly increases the expressibility of the
language, but we would really need another control to limit CPU usage.

	-hpa

