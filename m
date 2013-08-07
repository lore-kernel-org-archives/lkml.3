Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3HGX1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:27:45 -0400
Received: from server506h.appriver.com ([50.56.144.38]:58825 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752651Ab3HGX1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:27:43 -0400
X-Note-AR-ScanTimeLocal: 8/7/2013 6:27:42 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-Virus-Scan: V-
X-Note-SnifferID: 0
X-Note: TCH-CT/SI:0-34/SG:2 8/7/2013 6:27:40 PM
X-GBUdb-Analysis: 0, 10.242.229.139, Ugly c=1 p=-0.977973 Source White
X-Signature-Violations: 0-0-0-3945-c
X-Note-419: 0 ms. Fail:0 Chk:1343 of 1343 total
X-Note: SCH-CT/SI:0-1343/SG:1 8/7/2013 6:27:28 PM
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G319 G320 G321 G322 G326 G327 G434 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: VALID
X-Note: Headers Injected
Subject: Re: [PATCH] aoe: adjust ref of head for compound page tails
MIME-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org>
Date: Wed, 7 Aug 2013 19:27:40 -0400
CC: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <782613DB-4C38-450C-BBC2-E14FA64D44AC@coraid.com>
References: <cover.1375320764.git.ecashin@coraid.com> <0c8aff39249c1da6b9cc3356650149d065c3ebd2.1375320764.git.ecashin@coraid.com> <20130807140021.57a40fb31807f16b525f6ff3@linux-foundation.org> <EB4C2185-3868-42A3-A88D-F9642962D336@coraid.com> <20130807142647.6614d3ec88a7af12cba4505a@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1085)
X-Rerouted-By-Exchange: 
X-Rerouted-By-Exchange: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 7, 2013, at 5:26 PM, Andrew Morton wrote:

> On Wed, 7 Aug 2013 17:21:32 -0400 Ed Cashin <ecashin@coraid.com> wrote:
...
>> Sorry.  I tried to cover that but maybe should have separated it more clearly from the running text.
>> 
>> The patch changes the current behavior encountered with direct I/O and aoe:
>> 
>>  aoe can BUG when direct I/O used
>> 
>> ... to a new behavior:
>> 
>>  aoe does not BUG when direct I/O is used
>> 
>> And the user will never know that instead aoe is manipulating the _count of the head page, even though that's what's happening with this patch applied.
>> 
>> (The user-visible effects that motivated the older patch that added the BUG to aoe when page tails are used for block I/O was a VM_BUG_ON that occurred when the aoe driver manipulated the _count of a compound page tail.)
> 
> OK, I added "Fix a BUG which can trigger when direct-IO is used with
> AOE".  Which kernel versions are affected?


That BUG was added to the aoe driver in a commit that first appears in v3.7.  It persists until this patch adds the code that handles the situation that the BUG was intended to detect.

[ecashin@marino linux]$ git describe --contains --match 'v*' 69cf2d85de773d998798e47e3335b85e5645d157
v3.7-rc1~110^2~22
[ecashin@marino linux]$ 

-- 
  Ed Cashin
  ecashin@coraid.com


