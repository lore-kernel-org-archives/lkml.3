Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3KSDCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:02:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:57457 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3KSDCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <528ABFA3.6060905@zytor.com>
References: <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
	<20131114180455.GA32212@anatevka.fc.hp.com>
	<CAOJsxLFWMi8DoFp+ufri7XoFO27v+2=0oksh8+NhM6P-OdkOwg@mail.gmail.com>
	<20131115005049.GJ5116@anatevka.fc.hp.com>
	<20131115062417.GB9237@gmail.com>
	<CAE9FiQWzSTtW8N=0hoUe6iCSM-k64Mv97n0whAS0_vZ+psuOsg@mail.gmail.com>
	<5285C639.5040203@zytor.com>
	<20131115140738.GB6637@redhat.com>
	<CAE9FiQUnw9Ujmdtq-AgC4VctQ=fZSBkzehoTbvw=aZeARL+pwA@mail.gmail.com>
	<52865CA1.5020309@zytor.com>
	<20131115183002.GE6637@redhat.com>
	<528ABFA3.6060905@zytor.com>
Date: Mon, 18 Nov 2013 19:02:29 -0800
X-Google-Sender-Auth: tml-EH_5BqpSzYwjfRa5J_zK2hw
Message-ID: <CAE9FiQW+kbq5Eu-ivu897ogQUGjwKy6jYO9hnxbKyuWqoaQgJQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        jerry.hoemann@hp.com, Pekka Enberg <penberg@kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "list@ebiederm.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 5:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/15/2013 10:30 AM, Vivek Goyal wrote:
>>
>> And IOMMU support is very flaky with kdump. And IOMMU's can be turned
>> off at command line. And that would force one to remove crahkernel_low=0.
>> So change of one command line option forces change of another. It is
>> complicated.
>>
>> Also there are very few systems which work with IOMMU on. A lot more
>> which work without IOMMU. We have all these DMAR issues and still nobody
>> has been able to address IOMMU issues properly.
>>
>
> Why do we need such a big bounce buffer for kdump swiotlb anyway?
> Surely the vast majority of all dump devices don't need it, so it is
> there for completeness, no?

Yes, because normal path will need that 64M+32k default.

We may reduce that amount to 16M or 18M and in second kernel let
allocate less for swiotlb.

Thanks

Yinghai
