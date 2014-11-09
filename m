Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaKIJf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:35:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKIJfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:35:22 -0500
Message-ID: <545F3556.5000802@suse.cz>
Date: Sun, 09 Nov 2014 10:35:18 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "P. Christeas" <xrg@linux.gr>, Hillf Danton <hillf.zj@alibaba-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-mm@kvack.org
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
References: <00a801cffbd8$434189b0$c9c49d10$@alibaba-inc.com> <1433036.WjB5pb09Zh@xorhgos3.pefnos>
In-Reply-To: <1433036.WjB5pb09Zh@xorhgos3.pefnos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 09:22 AM, P. Christeas wrote:
> On Sunday 09 November 2014, Hillf Danton wrote:
>> -		return COMPACT_CONTINUE;
>> +		return COMPACT_SKIPPED;
> 
> I guess this one would mitigate against Vlastmil's migration scanner issue, 
> wouldn't it?

Please no, that's a wrong fix. The purpose of compaction is to make the
high-order watermark meet, not give up.

> In that case, I should wait a bit[1] to try the first patch, then revert, try 
> yours and (hopefully) have some results.

I hope my patch will be enough,

> Then, apply both.
> 
> [1] trying to push the vm by loading memory-hungry apps and random load.

Maybe the tools/testing/selftests/vm/transhuge-stress could help

