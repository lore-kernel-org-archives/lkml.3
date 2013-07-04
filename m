Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3GDLUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:20:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3GDLUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:20:51 -0400
X-AuditID: cbfee68f-b7f436d000000f81-70-51d55a910667
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>,
        "'Joerg Roedel'" <joro@8bytes.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>
References: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
 <CANEJEGvAYxdyq7iK6Y+YcgCFOKhA4+01=m4ofUs3ZE=Mwf7PRw@mail.gmail.com>
In-reply-to: <CANEJEGvAYxdyq7iK6Y+YcgCFOKhA4+01=m4ofUs3ZE=Mwf7PRw@mail.gmail.com>
Subject: RE: [PATCH v6 01/12] iommu/exynos: add missing cache flush for removed
 pagetable entries
Date: Thu, 04 Jul 2013 20:20:49 +0900
Message-id: <003301ce78a8$89218fc0$9b64af40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF6mRX1uhMmu1z9CGpAMvF6/V8qPQFJex6emfHSGgA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zQ92JUVcDDVacE7F4deQHk0Xn7A3s
	Fpd3zWFzYPZ4cnAek8fshossHp83yQUwR3HZpKTmZJalFunbJXBlnD/wmrngA0fFm+ZPzA2M
	/9i6GDk5JARMJI72n2aHsMUkLtxbDxTn4BASWMYo0ZoFU9J65ThTFyMXUHgRo8TaNb+gnL+M
	Esu3L2EFqWIT0JJYPfc4I4gtIuAnsWXlAbAFzAKaEj8X3wWrERKYyShxqtkVxOYUCJY4c+ID
	WL2wQLLEo+tzwOpZBFQlLr9eww5yBK+ApcSC58kgYV4BQYkfk++xQIxUl5g0bxEzhC0vsXnN
	W2aIQxUkdpx9DXWClUTLzzVQJ4hI7HvxjhHkZgmBfewSq9/sZYHYJSDxbfIhFpBdEgKyEpsO
	QM2RlDi44gbLBEaJWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmgOCm9yFivODG3uDQvXS85P3cT
	IyT++ncw3j1gfYgxGWj9RGYp0eR8YPzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoHx0AKJE49KOBT/uabNs8jfx+S6UytRjL3lerdl8zOBiEjv
	pc+l5pg+Uk5omShkep795rG+LtHDYflBklzqndOaui3FVSd7Pl36Y+KK5VLM4TkBCw7syVUv
	vLE+bmKo0kdjnTLfvCTJi7r6E1KNu/yd4qayT++Q4JQJ7XX6q3Yl8OpTNRHrGUosxRmJhlrM
	RcWJAOQZHkXVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jAd2JUVcDDRa/FLB4deQHk0Xn7A3s
	Fpd3zWFzYPZ4cnAek8fshossHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZpw/8Jq54ANHxZvmT8wNjP/Yuhg5OSQETCRarxxngrDFJC7cWw8U5+IQEljEKLF2
	zS8mCOcvo8Ty7UtYQarYBLQkVs89zghiiwj4SWxZeQBsErOApsTPxXfBaoQEZjJKnGp2BbE5
	BYIlzpz4AFYvLJAs8ej6HLB6FgFVicuv17B3MXJw8ApYSix4ngwS5hUQlPgx+R4LxEh1iUnz
	FjFD2PISm9e8ZYY4VEFix9nXUCdYSbT8XAN1gojEvhfvGCcwCs1CMmoWklGzkIyahaRlASPL
	KkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgCH8mvYNxVYPFIUYBDkYlHl4JqyuBQqyJZcWV
	uYcYJTiYlUR4nTiuBgrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjD55JXEGxqbmBlZGplZ
	GJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY2TV79vNAl2V36SSVC2aeWwES29b
	N66t5ZY5XFX1yuXs7ugFa1Qvtp59/2uOwVqd5Te3/5FLWH/lVNLd7dI3bgn8C6kx3tibseOy
	iRpPn9NbLYZVL541nJazfvt43mqdd15/NKfpyj9PF0sRrzba+CLawvZ0OA//xt60DzcD5VdZ
	+jBKCH09ocRSnJFoqMVcVJwIAMJRbYo0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Thursday, July 04, 2013 5:44 AM
> 
> Ping?
Hi.

Sorry for late update the patch set.
I am still working on the patch set when I am free.
Implementation of the updated patch set has been finished but not tested yet.

I will post the patches after simple test :)

Thank you.
> 
> On Mon, Jul 1, 2013 at 6:49 PM, Grant Grundler <grundler@chromium.org> wrote:
> > On Tuesday, December 25, 2012 6:00:01 PM UTC-8, Cho KyongHo wrote:
> >> This commit adds cache flush for removed small page and large page
> >> entries in exynos_iommu_unmap(). Missing cache flush of removed page
> >> table entries can cause missing page fault interrupt when a master IP
> >> accesses an unmapped area.
> >
> > KyongHo,
> > It appears this patch was never applied and got caught up in the
> > device tree binding discussion. AFAICT, this patch is still necessary.
> > Can you resubmit this patch separately. Or ok if I do?
> >
> > Original patch is here:
> >     https://patchwork.kernel.org/patch/1910261/
> >
> > thanks,
> > grant

