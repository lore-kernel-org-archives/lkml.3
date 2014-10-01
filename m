Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaJAVSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:18:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaJAVSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:18:45 -0400
Message-ID: <542C6FB2.8000503@suse.cz>
Date: Wed, 01 Oct 2014 23:18:42 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Xiubo Li <Li.Xiubo@freescale.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        minchan@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mm, compaction: using uninitialized_var insteads setting
 'flags' to 0 directly.
References: <1411961425-8045-1-git-send-email-Li.Xiubo@freescale.com> <542A5B5B.7060207@suse.cz> <alpine.DEB.2.02.1410011314180.21593@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1410011314180.21593@chino.kir.corp.google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 10:16 PM, David Rientjes wrote:
>> On 09/29/2014 05:30 AM, Xiubo Li wrote:
>> > Setting 'flags' to zero will be certainly a misleading way to avoid
>> > warning of 'flags' may be used uninitialized. uninitialized_var is
>> > a correct way because the warning is a false possitive.
>> 
>> Agree.
>> 
>> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>> 
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> 
> 
> I thought we just discussed this when 
> mm-compaction-fix-warning-of-flags-may-be-used-uninitialized.patch was 
> merged and, although I liked it, it was stated that we shouldn't add any 
> new users of uninitialized_var().

Yeah but that discussion wasn't unfortunately CC'd on mailing lists. And my
interpretation of the outcome is that maybe we should try :)

Also note that Arnd sent this kind of fix first, but that thread missed mailing
lists as well. CCing him at least.

Vlastimil
