Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3AQVco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:32:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30191 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3AQVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:32:43 -0500
Message-ID: <50F8B443.7070704@oracle.com>
Date: Thu, 17 Jan 2013 21:32:35 -0500
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.12) Gecko/20130105 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Matt Wilson <msw@amazon.com>, xen-devel@lists.xensource.com,
        annie.li@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of grants.
References: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com> <20130117110829.GA21859@u109add4315675089e695.ant.amazon.com> <50F8050C02000078000B6D33@nat28.tlf.novell.com>
In-Reply-To: <50F8050C02000078000B6D33@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/17/2013 8:05 AM, Jan Beulich wrote:
>>>> On 17.01.13 at 13:22, Matt Wilson<msw@amazon.com>  wrote:
>> On Wed, Jan 16, 2013 at 04:22:49PM -0500, Konrad Rzeszutek Wilk wrote:
>>> We have the framework to use v2, but there are no backends that
>>> actually use it. The end result is that on PV we use v2 grants
>>> and on PVHVM v1. The v1 has a capacity of 512 grants per page while
>>> the v2 has 256 grants per page. This means we lose about 50%
>>> capacity - and if we want more than 16 VIFs (each VIF takes
>>> 512 grants), then we are hitting the max per guest of 32.
>>>
>>> Note: The hypervisor provides an over-ride for the default
>>> of 32 frames (pages) per guest: gnttab_max_nr_frames=X
>> I think it would be better if the dom0/service domain and hypervisor
>> prevent the guest from setting the version to 2 if the backend isn't
>> going to make use of them. In the short term, we could add a Xen
>> option to limit the supported version to 1.
> But that's something each guest has to decide for itself.
>
> Anyway - if no-one's using v2, what did it get introduced for
> (not only in the hypervisor, but also in the kernel)? I thought
> the networking drivers were intended to make use of it...

That was the idea, but the work on that stalled. I think that once the 
netfront or netback has the right
code, then we can revert this patch - or just make this be more 
automatic and change itself to V2 if
it can.
> Jan
>
