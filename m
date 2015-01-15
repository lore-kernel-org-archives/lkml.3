Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbbAOXlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 18:41:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50586 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbbAOXlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 18:41:17 -0500
Message-ID: <54B85016.4080906@linux.vnet.ibm.com>
Date: Thu, 15 Jan 2015 15:41:10 -0800
From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linuxppc-dev@lists.ozlabs.org, Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pseries/le: Fix another endiannes issue in RTAS call
 from xmon
References: <1421295950.11409.3.camel@ellerman.id.au> <1421342627-7214-1-git-send-email-ldufour@linux.vnet.ibm.com> <54B8188D.1060907@linux.vnet.ibm.com> <1421360377.23332.1.camel@ellerman.id.au>
In-Reply-To: <1421360377.23332.1.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011523-0029-0000-0000-000001B1841B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:19 PM, Michael Ellerman wrote:
> On Thu, 2015-01-15 at 11:44 -0800, Tyrel Datwyler wrote:
>> On 01/15/2015 09:23 AM, Laurent Dufour wrote:
>>> The commit 3b8a3c010969 ("powerpc/pseries: Fix endiannes issue in RTAS
>>> call from xmon") was fixing an endianness issue in the call made from
>>> xmon to RTAS.
>>>
>>> However, as Michael Ellerman noticed, this fix was not complete, the
>>> token value was not byte swapped. This lead to call an unexpected and
>>> most of the time unexisting RTAS function, which is silently ignored
>>> by RTAS.
>>
>> Nit. Not so much that is silently ignored by RTAS as much as
>> disable_surveillance silently doesn't check the return status of the
>> RTAS call. Maybe a check is warranted and reporting of non-success.
> 
> Yeah you're right, I added a printf of the result and got -3, which is also
> wrong as far as I can tell, but I didn't have the energy to chase it any
> further.

If this was on a powerkvm guest set-indicator should be present for
hotplug (DLPAR) support. However, the surveillance indicator would not
be implemented. I know sometimes I forget if I'm on a powervm or
powerkvm guest. Just a thought.

-Tyrel

> 
> Because this is in xmon we want to be extra careful about what we do, but an
> xmon_printf() should be safe. I'll do that as a cleanup after this.
> 
> cheers
> 
> 

