Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaKGQyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:54:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaKGQyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:54:19 -0500
Message-ID: <545CF938.7050906@suse.cz>
Date: Fri, 07 Nov 2014 17:54:16 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>, David Rientjes <rientjes@google.com>,
        linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: 3.18-rc3: soft lockup in compact_zone, dead machine
References: <20141107100611.GA4175@amd>
In-Reply-To: <20141107100611.GA4175@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 11:06 AM, Pavel Machek wrote:
> Hi!
>
> My main machine died completely, it seems that original failure was
> soft lockup in compact_zone().

(expanding CC)

Welcome to the club...

http://article.gmane.org/gmane.linux.kernel.mm/124451/match=isolate_freepages_block+very+high+intermittent+overhead

https://lkml.org/lkml/2014/11/4/144

https://lkml.org/lkml/2014/11/4/904

How reproducible is your case? So far it seems that git revert 
e14c720efdd73c6d69cd8d07fa894bcd11fe1973 helped one of the reporters.
I still don't know what's wrong, but suspect a free scanner 
(cc->free_pfn) position being broken (i.e. underflow), which would allow 
isolate_migratepages() to run for a loooooooong time. The code does 
cond_resched() periodically, so soft lockup looks strange, but I guess 
that can happen in some contexts?

Vlastimil



