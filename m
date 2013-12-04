Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3LDQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:57:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35587 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3LDQ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:57:34 -0500
Message-ID: <529F5EF9.5010707@wwwdotorg.org>
Date: Wed, 04 Dec 2013 09:57:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>, Alex Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: tegra: switch FUSE clock on before usage
References: <1385001613-19098-1-git-send-email-acourbot@nvidia.com> <528E6D58.6050503@wwwdotorg.org> <528EB4EE.309@nvidia.com> <CAAVeFuJpHXCANRO=AT5mKGpHzJRpmQoOuX4hjsctEMMAMjgqnQ@mail.gmail.com>
In-Reply-To: <CAAVeFuJpHXCANRO=AT5mKGpHzJRpmQoOuX4hjsctEMMAMjgqnQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 12:09 AM, Alexandre Courbot wrote:
> Hi Stephen,
> 
> On Fri, Nov 22, 2013 at 10:35 AM, Alex Courbot <acourbot@nvidia.com> wrote:
>> On 11/22/2013 05:30 AM, Stephen Warren wrote:
>>>
>>> On 11/20/2013 07:40 PM, Alexandre Courbot wrote:
>>>>
>>>> FUSE clock is enabled by most bootloaders, but we cannot expect it to be
>>>> on in all contexts (e.g. kexec).
>>>>
>>>> Ensure the FUSE clock is enabled before any of its registers is touched.
>>>> Since FUSE is touched very early during system boot (before the clock
>>>> devices are registered), directly manipulate the clock register bit in
>>>> case the clock device cannot be acquired.
>>>
>>>
>>> This looks reasonable to me. I'll apply it soon after -rc1.
>>
>>
>> Thanks. Be careful as I noticed I misformatted my commit message. The part
>> after the "--" will not be stripped by git am as I intended it to be. I
>> understood what I did wrong and will hopefully not make that mistake again.
>>
>> Sorry for the inconvenience.
> 
> I am not seeing this in your tree, have you applied it somewhere already?

I haven't applied anything for 3.14 yet. I was hoping to get the
DMA/clock/reset DT binding rework in first, but it's been dragging on
for while, so I'll probably take a look at what can be applied without
conflicting with that soon.

