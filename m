Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3LKQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:24:04 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9044 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3LKQYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:24:02 -0500
X-IronPort-AV: E=Sophos;i="4.93,872,1378857600"; 
   d="scan'208";a="80957930"
Message-ID: <52A8919E.2000805@citrix.com>
Date: Wed, 11 Dec 2013 17:23:58 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com> <529DBA07.6090108@citrix.com> <1386068884.13256.9.camel@kazak.uk.xensource.com> <529DC7BA.7080506@citrix.com> <1386078108.13256.30.camel@kazak.uk.xensource.com> <529DF4A0.50103@citrix.com> <1386083821.13256.42.camel@kazak.uk.xensource.com> <20131203201135.GA14243@phenom.dumpdata.com> <alpine.DEB.2.02.1312111618120.7093@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1312111618120.7093@kaball.uk.xensource.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 17:18, Stefano Stabellini wrote:
> On Tue, 3 Dec 2013, Konrad Rzeszutek Wilk wrote:
>>>> If Konrad and Boris agree that breaking the kernel's ABI in this way is
>>>> acceptable in this specific case, I'll defer to them.
>>>
>>> My opinion as Xen on ARM hypervisor maintainer is that this is the right
>>> thing to do in this case.
>>
>> Heh. If somebody can guarantee me that (by testing the right variants and
>> mentioning this in the git commit) that this does not break x86, then
>> I am fine.
>>
>> And by 'break x86' I mean that this combination works:
>>  32-bit domU on 64-bit dom0
>>  64-bit domU on 32-bit dom0
>>
>> And perhaps also the obvious:
>>  64-bit domU on 64-bit dom0
>>  32-bit domU on 32-bit dom0
>>
>> Since the xen-blkback has its own version of the structs there is no
>> need to change change newer and older version of it.
>>
>> As long as that works I am OK sticking it in.
>>
>> I think from the ARM perspective it is still in 'experimental' phase
>> so anything goes to make it work under ARM.
> 
> 
> Roger, can you please test this patch on x86 as suggested by Konrad and
> confirm that it doesn't break anything?

This is not the right patch, the right one is the one posted by Julien:

http://marc.info/?l=linux-kernel&m=138608528604584&w=2

