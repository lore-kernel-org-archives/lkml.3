Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3L0Kjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:39:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41463 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3L0Kjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:39:47 -0500
X-IronPort-AV: E=Sophos;i="4.95,560,1384272000"; 
   d="scan'208";a="9337092"
Message-ID: <52BD5738.4010308@cn.fujitsu.com>
Date: Fri, 27 Dec 2013 18:32:24 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Benjamin <bcrl@kvack.org>, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aio: optimize free kioctx slot search
References: <52BC0352.2040504@cn.fujitsu.com> <20131226141356.GH11091@parisc-linux.org>
In-Reply-To: <20131226141356.GH11091@parisc-linux.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:38:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:39:01,
	Serialize complete at 2013/12/27 18:39:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,
On 12/26/2013 10:13 PM, Matthew Wilcox wrote:

> On Thu, Dec 26, 2013 at 06:22:10PM +0800, Gu Zheng wrote:
>> to the new free slot if it's smaller than 'next_free'. So that we can
>> ensure that the slots before 'next_free' are all used, and the search can start
>> from 'next_free' to reduce the search and improve the performance.
> 
> Have you benchmarked it?  What kinds of improvements are you seeing?

Not yet. But the improvement is obvious, we can always reduce the search region and
improve the hit rate when trying to find a free slot with this change.

Regards,
Gu

> 


