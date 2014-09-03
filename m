Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaICOxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:53:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39700 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaICOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:53:12 -0400
X-IronPort-AV: E=Sophos;i="5.04,457,1406592000"; 
   d="scan'208";a="168721455"
Message-ID: <54072B52.3070104@citrix.com>
Date: Wed, 3 Sep 2014 15:53:06 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V2 PATCH 1/1] PVH: set EFER.NX and EFER.SCE
References: <1409707176-16487-1-git-send-email-mukesh.rathor@oracle.com>	<1409707176-16487-2-git-send-email-mukesh.rathor@oracle.com>	<54071E6C.4080901@citrix.com> <54072A63.6080704@oracle.com>
In-Reply-To: <54072A63.6080704@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 15:49, Boris Ostrovsky wrote:
> On 09/03/2014 09:58 AM, David Vrabel wrote:
>
>>   #endif
>> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
>> index 485b695..a64b464 100644
>> --- a/arch/x86/xen/xen-head.S
>> +++ b/arch/x86/xen/xen-head.S
>> @@ -47,6 +47,40 @@ ENTRY(startup_xen)
>>         __FINIT
>>   +#ifdef CONFIG_XEN_PVH
>> +#ifdef CONFIG_X86_64
>
> CONFIG_XEN_PVH implies CONFIG_X86_64.
>
> -boris

Only because PVH is currently mal-specified and limited to 64bit.  It
will certainly not be true when PVH gains 32bit support.

~Andrew

>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

