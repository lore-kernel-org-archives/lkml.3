Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3JDNvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:51:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18594 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3JDNvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:51:09 -0400
X-IronPort-AV: E=Sophos;i="4.90,1033,1371081600"; 
   d="scan'208";a="57748334"
Message-ID: <524EC3C1.4010304@citrix.com>
Date: Fri, 4 Oct 2013 14:33:53 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Frediano Ziglio <frediano.ziglio@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: Fix possible user space selector corruption
References: <1380788677.30462.1.camel@hamster.uk.xensource.com> <524D4132.3000809@citrix.com> <1380804692.30462.3.camel@hamster.uk.xensource.com> <20131004132033.GA26673@phenom.dumpdata.com>
In-Reply-To: <20131004132033.GA26673@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/13 14:20, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 03, 2013 at 01:51:32PM +0100, Frediano Ziglio wrote:
>> On Thu, 2013-10-03 at 11:04 +0100, Andrew Cooper wrote:
>>> On 03/10/13 09:24, Frediano Ziglio wrote:
>>>>
>>>> Bisecting the code commit 7076aada1040de4ed79a5977dbabdb5e5ea5e249 appears
>>>> to be the first one that have this issue.
>>>>
>>>> Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
>>> In terms of the correctness of the fix,
>>>
>>> Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
> Should this also go in stable tree?

Very much so.  The change which exposed it for us was from 3.7 iirc, but
I believe it has been a latent bug for as long as the native early boot
code uses __USER_DS.

>>> However, I am not sure the comment is necessary.  The prevailing style
>>> is for no justification of loads of segment selectors on boot, and the
>>> comment itself refers simply to an interaction issue of 32bit on Xen
>>> when making use of sysenter.
>>>
>> Suggestion for the comment ??
>>
>> Frediano

My suggestion was to omit the comment entirely, or simplify it to just:

/* Xen starts us with XEN_FLAT_RING1_DS, but linux code expects __USER_DS */

Anyone who wants the full explanation can read the patch description.

~Andrew
