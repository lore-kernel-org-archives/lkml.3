Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3GaX3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:29:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43481 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3GaX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:29:44 -0400
Message-ID: <51F99DE4.7010503@wwwdotorg.org>
Date: Wed, 31 Jul 2013 17:29:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH 2/2] ARM: dts: USB for Tegra114 Dalmore
References: <1375292543-7896-1-git-send-email-ttynkkynen@nvidia.com> <1375292543-7896-3-git-send-email-ttynkkynen@nvidia.com> <51F9550F.3080503@cogentembedded.com> <51F9660C.6090604@iki.fi> <51F96B48.10209@cogentembedded.com> <51F98A78.9060309@wwwdotorg.org> <51F98D92.3010607@cogentembedded.com>
In-Reply-To: <51F98D92.3010607@cogentembedded.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 04:20 PM, Sergei Shtylyov wrote:
> On 08/01/2013 02:06 AM, Stephen Warren wrote:
...
>>>     That's really horrible design.
>>
>> Yup. Both USB PHY and EHCI controller registers really are interleaved
>> in one range.
> 
>    But the standard EHCI register space has no holes IIRC, so they can't
> be really that much interleaved as you're describing (unless you have
> some non-standard registers of course)...

Yes, there are certainly non-standard registers.

...
>>>     Don't they cause numerous resource conflicts while device nodes
>>> being
>>> instantiated as the platform devices?
> 
>> No; the driver knows that the HW is screwy and there's lots of
>> register-range sharing going on, so it simply maps the registers, rather
>> than reserving the physical address range and mapping it.
> 
>    Yes, it's clear that the driver should take special measures, I was
> asking about the platform device creation phase. What do you see in
> /proc/iomem?

The drivers don't request the memory region since doing so would cause
conflicts. Hence, the regions don't show up in /proc/iomem.

This actually isn't that uncommon for DT-based drivers anyway; many use
e.g. of_iomap() which IIRC just looks up the resource and maps it
without registering the usage.
