Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3IQNeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:34:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3IQNeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:34:21 -0400
Message-ID: <52385A59.2080304@suse.cz>
Date: Tue, 17 Sep 2013 15:34:17 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [munlock] BUG: Bad page map in process killall5 pte:53425553
 pmd:075f4067
References: <20130916084752.GC11479@localhost> <52372349.6030308@suse.cz> <20130917132910.GA16186@localhost>
In-Reply-To: <20130917132910.GA16186@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 03:29 PM, Fengguang Wu wrote:
> Hi Vlastimil,
> 
>>
>> Also, some of the failures during bisect were not due to this bug, but a WARNING for
>> list_add corruption which hopefully is not related to munlock. While it is probably a far stretch,
>> some kind of memory corruption could also lead to the erroneous behavior of the munlock code.
>>
>> Can you therefore please retest with the bisected patch reverted (patch below) to see if the other
>> WARNING still occurs and can be dealt with separately, so there are not potentially two bugs to
>> be chased at the same time?
> 
> Yes there seems to be one more bug, the attached dmesg is for the
> kernel with your patch reverted. I'm trying to bisect the other bug
> now.

Thanks. Meanwhile I was able to reproduce the bug in my patch in a VM
with x86_32 without PAE. As it turns out, pmd_addr_end() on such
configuration without pmd really does not bound the address to page
table boundary, but is a no-op. Working on a fix.

Vlastimil

> Thanks,
> Fengguang
> 

