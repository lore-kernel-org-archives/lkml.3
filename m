Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbaFLMBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:01:01 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62503 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123AbaFLMA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:00:58 -0400
MIME-Version: 1.0
X-Originating-IP: [5.35.52.78]
In-Reply-To: <CAOJe8K3LDhhPWbtdaWt23mY+2vnw5p05+eyk2D8fovOxC10cgA@mail.gmail.com>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com>
	<20140611173851.GA5556@MacBook-Pro.local>
	<CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com>
	<B01EB0A1-992B-49F4-93AE-71E4BA707795@arm.com>
	<CAOJe8K3LDhhPWbtdaWt23mY+2vnw5p05+eyk2D8fovOxC10cgA@mail.gmail.com>
Date: Thu, 12 Jun 2014 16:00:57 +0400
Message-ID: <CAOJe8K2WaJUP9_buwgKw89fxGe56mGP1Mn8rDUO9W48KZzmybA@mail.gmail.com>
Subject: Re: kmemleak: Unable to handle kernel paging request
From: Denis Kirjanov <kda@linux-powerpc.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/14, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> On 6/12/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On 11 Jun 2014, at 21:04, Denis Kirjanov <kda@linux-powerpc.org> wrote:
>>> On 6/11/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
>>>> On Wed, Jun 11, 2014 at 04:13:07PM +0400, Denis Kirjanov wrote:
>>>>> I got a trace while running 3.15.0-08556-gdfb9454:
>>>>>
>>>>> [  104.534026] Unable to handle kernel paging request for data at
>>>>> address 0xc00000007f000000
>>>>
>>>> Were there any kmemleak messages prior to this, like "kmemleak
>>>> disabled"? There could be a race when kmemleak is disabled because of
>>>> some fatal (for kmemleak) error while the scanning is taking place
>>>> (which needs some more thinking to fix properly).
>>>
>>> No. I checked for the similar problem and didn't find anything relevant.
>>> I'll try to bisect it.
>>
>> Does this happen soon after boot? I guess it’s the first scan
>> (scheduled at around 1min after boot). Something seems to be telling
>> kmemleak that there is a valid memory block at 0xc00000007f000000.
>
> Yeah, it happens after a while with a booted system so that's the
> first kmemleak scan.
>
>> Catalin
>

I've bisected to this commit: d4c54919ed86302094c0ca7d48a8cbd4ee753e92
"mm: add !pte_present() check on existing hugetlb_entry callbacks".
Reverting the commit fixes the issue
