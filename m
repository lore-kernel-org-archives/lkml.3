Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaHZUkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:40:14 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50649 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHZUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:40:13 -0400
Message-ID: <53FCF0A9.60400@gmail.com>
Date: Tue, 26 Aug 2014 13:40:09 -0700
From: Matthew Rushton <mvrushton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
CC: msw@amazon.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v2 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1405814495-10868-1-git-send-email-mrushton@amazon.com> <1405814495-10868-2-git-send-email-mrushton@amazon.com> <53DA805D.4020300@citrix.com> <53DBA9AC.8000302@citrix.com>
In-Reply-To: <53DBA9AC.8000302@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 07:52, David Vrabel wrote:
> On 31/07/14 18:43, David Vrabel wrote:
>> On 20/07/14 01:01, Matt Rushton wrote:
>>> Instead of ballooning up and down dom0 memory this remaps the existing mfns
>>> that were replaced by the identity map. The reason for this is that the
>>> existing implementation ballooned memory up and and down which caused dom0
>>> to have discontiguous pages. In some cases this resulted in the use of bounce
>>> buffers which reduced network I/O performance significantly. This change will
>>> honor the existing order of the pages with the exception of some boundary
>>> conditions.
>>>
>>> To do this we need to update both the Linux p2m table and the Xen m2p table.
>>> Particular care must be taken when updating the p2m table since it's important
>>> to limit table memory consumption and reuse the existing leaf pages which get
>>> freed when an entire leaf page is set to the identity map. To implement this,
>>> mapping updates are grouped into blocks with table entries getting cached
>>> temporarily and then released.
>>>
>>> On my test system before:
>>> Total pages: 2105014
>>> Total contiguous: 1640635
>>>
>>> After:
>>> Total pages: 2105014
>>> Total contiguous: 2098904
>> Applied to devel/for-linus-3.17
> Unfortunately, this produces too many WARNINGs on some boxes or
> with certain configurations.
>
> I will remove this patch from the queue for 3.17.
>

Have you had a chance to try the v3 patch set?


