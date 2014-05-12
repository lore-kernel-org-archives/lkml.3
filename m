Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbaELMBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:01:15 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56827 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbaELMBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:01:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pintu Kumar <pintu.k@outlook.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Re: Questions regarding DMA buffer sharing using IOMMU
Date: Mon, 12 May 2014 14:00:57 +0200
Message-ID: <5218408.5YRJXjS4BX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <BAY169-W12541AD089785F8BFBD4E26EF350@phx.gbl>
References: <BAY169-W12541AD089785F8BFBD4E26EF350@phx.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2Eg78QNEGNsH82RsK5CCP8K4wWwu8lFHd4ZjIJjDyF/
 dvYa+VAQuhkeow3iDVleIjc6cxq+3BVg5bPFf8FVP507aYV3ZR
 JRJlwP7+Oh96e5XR1GIcoVPPkA03V6AXDN3y58zQ8dE8zyjebq
 vI6Bt6EqbtfPt46v5Wef02N/iGiG7ylcf2xJK09qQmRLyScAPz
 QUZcMRU7jsPGu2L3ZYmPDHgQSMXGJlTS2lZI1flSy1CyPxXO0F
 nnGmB7JTaot7fYwjw/hAENL7DBM92WTVkePFnCjD9fSD4H2Hck
 URWNuoe0g3r2yllGzS+zC3fYPAj0AVfrs/3tojGHMDtYsCf9Ce
 9nJo1bV8BYiEUL9PHH68=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 15:12:41 Pintu Kumar wrote:
> Hi, 
> I have some queries regarding IOMMU and CMA buffer sharing. 
> We have an embedded linux device (kernel 3.10, RAM: 256Mb) in 
> which camera and codec supports IOMMU but the display does not support IOMMU. 
> Thus for camera capture we are using iommu buffers using
> ION/DMABUF. But for all display rendering we are using CMA buffers. 
> So, the question is how to achieve buffer sharing (zero-copy)
> between Camera and Display using only IOMMU? 
> Currently we are achieving zero-copy using CMA. And we are
> exploring options to use IOMMU. 
> Now we wanted to know which option is better? To use IOMMU or CMA? 
> If anybody have come across these design please share your thoughts and results. 

There is a slight performance overhead in using the IOMMU in general,
because the IOMMU has to fetch the page table entries from memory
at least some of the time.

If that overhead is within the constraints you have for transfers between
camera and codec, you are always better off using IOMMU since that
means you don't have to do memory migration.

Note however, that we don't have a way to describe IOMMU relations
to devices in DT, so whatever you come up with to do this will most
likely be incompatible with what we do in future kernel versions.

	Arnd
