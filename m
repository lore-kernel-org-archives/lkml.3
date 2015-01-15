Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbbAOLHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:07:24 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43580 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbbAOLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:07:22 -0500
Message-ID: <54B79F5F.1040806@de.ibm.com>
Date: Thu, 15 Jan 2015 12:07:11 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org,
        xen-devel@lists.xenproject.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [Xen-devel] [PATCH 3/8] x86/xen/p2m: Replace ACCESS_ONCE with
 READ_ONCE
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com> <1421312314-72330-4-git-send-email-borntraeger@de.ibm.com> <54B799DC.1050008@citrix.com>
In-Reply-To: <54B799DC.1050008@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011511-0021-0000-0000-0000028DF1C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.01.2015 um 11:43 schrieb David Vrabel:
> On 15/01/15 08:58, Christian Borntraeger wrote:
>> ACCESS_ONCE does not work reliably on non-scalar types. For
>> example gcc 4.6 and 4.7 might remove the volatile tag for such
>> accesses during the SRA (scalar replacement of aggregates) step
>> (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
>>
>> Change the p2m code to replace ACCESS_ONCE with READ_ONCE.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>

Thanks

> Let me know if you want me to merge this via the Xen tree.


With your Acked-by, I can easily carry this in my tree. We can 
then ensure that this patch is merged before the ACCESS_ONCE is
made stricter - making bisecting easier.

Christian

