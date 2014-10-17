Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaJQEXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 00:23:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaJQEXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 00:23:16 -0400
Message-ID: <544099B1.4090202@suse.com>
Date: Fri, 17 Oct 2014 06:23:13 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com
Subject: Re: [PATCH] xen: avoid race in p2m handling
References: <1413439997-32344-1-git-send-email-jgross@suse.com> <543FE940.60901@citrix.com>
In-Reply-To: <543FE940.60901@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 05:50 PM, David Vrabel wrote:
> On 16/10/14 07:13, Juergen Gross wrote:
>> When a new p2m leaf is allocated this leaf is linked into the p2m tree
>> via cmpxchg. Unfortunately the compare value for checking the success
>> of the update is read after checking for the need of a new leaf. It is
>> possible that a new leaf has been linked into the tree concurrently
>> in between. This could lead to a leaked memory page and to the loss of
>> some p2m entries.
>>
>> Avoid the race by using the read compare value for checking the need
>> of a new p2m leaf.
> [...]
>> @@ -579,11 +580,10 @@ static bool alloc_p2m(unsigned long pfn)
>>   		}
>>   	}
>>
>> -	if (p2m_top[topidx][mididx] == p2m_identity ||
>> -	    p2m_top[topidx][mididx] == p2m_missing) {
>> +	p2m_orig = p2m_top[topidx][mididx];
>
> Do you need to use ACCESS_ONCE() here?

Yes, you are probably right. Should I send a new patch or do you want
to modify it?

Juergen

