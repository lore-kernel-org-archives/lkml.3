Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHRPqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:46:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:16627 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaHRPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,886,1400050800"; 
   d="scan'208";a="469919744"
Message-ID: <53F21FB1.7060607@intel.com>
Date: Mon, 18 Aug 2014 08:45:53 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Krzysztof Majzerowicz-Jaszcz <cristos@vipserv.org>,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: ethernet: intel: e1000: e1000_ethtool.c
 coding style fixes
References: <1408180328-4827-1-git-send-email-cristos@vipserv.org>	 <1408214489.2683.87.camel@joe-AO725> <53F21BEC.2070204@intel.com> <1408375914.2741.1.camel@joe-AO725>
In-Reply-To: <1408375914.2741.1.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 08:31 AM, Joe Perches wrote:
> On Mon, 2014-08-18 at 08:29 -0700, Alexander Duyck wrote:
>> Doing any kind of pointer math on a void pointer is generally unsafe as
>> it is an incomplete type.  The only reason why it works in GCC is
>> because GCC has a nonstandard extension that makes it report as having a
>> size of 1.
> 
> I know.  It's used in quite a few places in kernel code
> so I believe it's now a base assumption for the kernel.

Well that is something that should probably be fixed then.  I don't
believe it is safe to be doing any kind of pointer math on a void pointer.

We really shouldn't be using any GCC specific bits unless we absolutely
have to.

Thanks,

Alex

