Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaHBAwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 20:52:54 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46115 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaHBAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 20:52:52 -0400
Message-ID: <53DC3660.6050104@gmail.com>
Date: Fri, 01 Aug 2014 17:52:48 -0700
From: Matthew Rushton <mvrushton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Matt Wilson <msw@linux.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, msw@amazon.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v2 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1405814495-10868-1-git-send-email-mrushton@amazon.com> <1405814495-10868-2-git-send-email-mrushton@amazon.com> <53DA805D.4020300@citrix.com> <53DBA9AC.8000302@citrix.com> <20140801155206.GA13865@u109add4315675089e695.ant.amazon.com> <53DBB8BA.3030909@oracle.com>
In-Reply-To: <53DBB8BA.3030909@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 08:56, Boris Ostrovsky wrote:
> On 08/01/2014 11:52 AM, Matt Wilson wrote:
>> On Fri, Aug 01, 2014 at 03:52:28PM +0100, David Vrabel wrote:
>>> On 31/07/14 18:43, David Vrabel wrote:
>>>> On 20/07/14 01:01, Matt Rushton wrote:
>>>>> Instead of ballooning up and down dom0 memory this remaps the 
>>>>> existing mfns
>>>>> that were replaced by the identity map. The reason for this is 
>>>>> that the
>>>>> existing implementation ballooned memory up and and down which 
>>>>> caused dom0
>>>>> to have discontiguous pages. In some cases this resulted in the 
>>>>> use of bounce
>>>>> buffers which reduced network I/O performance significantly. This 
>>>>> change will
>>>>> honor the existing order of the pages with the exception of some 
>>>>> boundary
>>>>> conditions.
>>>>>
>>>>> To do this we need to update both the Linux p2m table and the Xen 
>>>>> m2p table.
>>>>> Particular care must be taken when updating the p2m table since 
>>>>> it's important
>>>>> to limit table memory consumption and reuse the existing leaf 
>>>>> pages which get
>>>>> freed when an entire leaf page is set to the identity map. To 
>>>>> implement this,
>>>>> mapping updates are grouped into blocks with table entries getting 
>>>>> cached
>>>>> temporarily and then released.
>>>>>
>>>>> On my test system before:
>>>>> Total pages: 2105014
>>>>> Total contiguous: 1640635
>>>>>
>>>>> After:
>>>>> Total pages: 2105014
>>>>> Total contiguous: 2098904
>>>> Applied to devel/for-linus-3.17
>>> Unfortunately, this produces too many WARNINGs on some boxes or
>>> with certain configurations.
>> Hi David,
>>
>> Do you have more information about the systems or configurations that
>> showed a problem?
>>
>
>
> This appears to be happening on 32-bit dom0.
>
> -boris

It's unclear to me why the m2p update would be failing in this case (on 
first attempt) which causes the subsequent errors. I'll try to repro on 
a 32-bit dom0.

