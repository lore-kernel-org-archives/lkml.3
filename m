Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3IZAvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:51:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24631 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3IZAva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:51:30 -0400
X-Spam-Score: -100.8
Message-ID: <524384D1.6020009@asianux.com>
Date: Thu, 26 Sep 2013 08:50:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: include: asm: use 'long long' instead of 'u64'
 for atomic64_t and its related functions
References: <52426310.4020204@asianux.com> <524338F6.2090508@tilera.com>
In-Reply-To: <524338F6.2090508@tilera.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 03:26 AM, Chris Metcalf wrote:
> On 9/25/2013 12:14 AM, Chen Gang wrote:
>> atomic* value is signed value, and atomic* functions need also process
>> signed value (parameter value, and return value), so use 'long long'
>> instead of 'u64'.
>>
>> After replacement, it will also fix a bug for atomic64_add_negative():
>> "u64 is never less than 0".
>>
>> The modifications are:
>>
>>   in vim, use "1,% s/\<u64\>/long long/g" command.
>>   remove redundant '__aligned(8)' and a type case '(u64 *)'.
>>   be sure of 80 (and macro '\') columns limitation after replacement.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> ---
>>  arch/tile/include/asm/atomic.h    |    5 +++--
>>  arch/tile/include/asm/atomic_32.h |   27 +++++++++++++++------------
>>  arch/tile/include/asm/cmpxchg.h   |   28 +++++++++++++++++-----------
>>  arch/tile/lib/atomic_32.c         |    8 ++++----
>>  4 files changed, 39 insertions(+), 29 deletions(-)
> 
> Thanks!  Taken into the tile tree for 3.12.
> 

Thank you too.

-- 
Chen Gang
