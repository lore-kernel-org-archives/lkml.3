Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaFZWLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 18:11:32 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35994 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaFZWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 18:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAAObsKDVrXRgO1e2=SorGiNUMhGPCCUUPtsjDfnST9gFN4=qTQ@mail.gmail.com>
References: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
 <44039675.8s16pHQIVH@wuerfel> <20140625182349.32686.25931@quantum> <CAAObsKDVrXRgO1e2=SorGiNUMhGPCCUUPtsjDfnST9gFN4=qTQ@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 26 Jun 2014 15:11:09 -0700
Message-ID: <CAPtuhTgp2Ubr-9CiVGeJjG91J765dYKcY3gF+i+o1MTf2ELKPA@mail.gmail.com>
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:37 AM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> On 25 June 2014 20:23, Mike Turquette <mturquette@linaro.org> wrote:
>>
>> Peter,
>>
>> Just FYI, I'm trying to reverse the trend of prepending double
>> underscores for functions that are used by clock providers. That stuff
>> started out small and sort of grew out of control ;-)
>
> I'm looking at rebasing Rabin's patches for per-user clks, and I have
> had to add a few variants for providers, so they can be called with
> clk_core instead. Have been prepending underscores for those internal
> variants, but in some cases I had to also append a _internal suffix
> because there were already variants without locking.
>
> What convention were you thinking of for distinguishing provider-only
> variants for e.g. clk_set_rate?

Hmm. Now we need a convention. Damn. ;-)

I'm open to suggestions. I think prepending a single underscore makes
great sense for a lock-free inner function. And some number of
underscores (1 or 2) makes sense for static functions not exposed to
clock providers. I kind of like using 2 underscores for the static
functions so that it is easier to differentiate them.

For any new functions you create with unique names that are exposed to
clock providers, do not prepend any underscore at all. It's just
another public function in clk-provider.h.

If any taste makers out there have suggestions I am happy to listen.

Regards,
Mike

>
> Regards,
>
> Tomeu
