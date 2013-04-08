Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935451Ab3DHShJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:37:09 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:55855 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934738Ab3DHShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <51626D3D.4000907@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org>
	<1365113821-22749-2-git-send-email-yinghai@kernel.org>
	<51626D3D.4000907@redhat.com>
Date: Mon, 8 Apr 2013 11:37:06 -0700
X-Google-Sender-Auth: 0bB0aOBOeRbJDonrQzvl8xczMHk
Message-ID: <CAE9FiQUsMGmF2PXMD2W+f7oYBJVudccxoWnisLEsDxXzGgoi0g@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 12:09 AM, Dave Young <dyoung@redhat.com> wrote:
>> We have now modified crashkernel=X to allocate memory beyong 4G (if
>> available) and do not allocate low range for crashkernel if the user
>> does not specify that with crashkernel_low=Y.  This causes regression
>> if iommu is not enabled.  Without iommu, swiotlb needs to be setup in
>> first 4G and there is no low memory available to second kernel.
>
> Is it possible to reuse the 1st kernel swiotlb region in 2nd capture
> kernel if it's available?

If the first kernel is using intel iommu, and swiotlb is freed after intel
iommus is enabled in first kernel.

>
>>
>> Set crashkernel_low automatically if the user does not specify that.
>>
>> For system that does support IOMMU with kdump properly, user could
>> specify crashkernel_low=0 to save that 72M low ram.
>
> How about make swiotlb size tunable in 1st kernel as well such as adding
> a swiotlb_size= to cmdline, if it's set in 1st kernel crashkernel
> reserving code can take it automaticlly.
>
can not understand this.

Thanks

Yinghai
