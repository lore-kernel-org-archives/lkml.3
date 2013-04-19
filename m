Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006Ab3DSWDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 18:03:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55562 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964936Ab3DSWDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 18:03:16 -0400
Message-ID: <5171BF0A.8010402@zytor.com>
Date: Fri, 19 Apr 2013 15:02:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419191128.GA21991@pd.tnic> <5171AA86.604@nexus-software.ie> <20130419205515.GA3075@pd.tnic> <20130419212514.GC3075@pd.tnic> <5171BAD6.4040003@nexus-software.ie>
In-Reply-To: <5171BAD6.4040003@nexus-software.ie>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 02:44 PM, Bryan O'Donoghue wrote:
> On 19/04/13 22:25, Borislav Petkov wrote:
>> On Fri, Apr 19, 2013 at 10:55:15PM +0200, Borislav Petkov wrote:
>>> Just filter out P5 and earlier. The code already does that for CPUs
>>> which don't have CPUID.
>>
>> Actually, an alternative - more practical albeit not very accurate
> 
> More practical ? Hmm - the MSRs don't exist for < P5

Yes, and that is definitional.

I like doing this check before boring down in the code too far, however,
I want to make it so that it is structurally clear that this is for
Intel; other CPU vendors might theoretically have other criteria.

Architecturally, I would prefer to do this check early in
load_ucode_intel_{bsp,ap}() but I would be okay with putting it in
load_ucode_bsp()/local_ucode_ap() as well as long as the test is
conditional on the Intel vendor check.

More importantly, though: I really would like to get a fix *today*.

	-hpa

