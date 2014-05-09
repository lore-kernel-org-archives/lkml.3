Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaEIIOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:14:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54272 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaEIIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:13:56 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-df-536c8e409f44
Message-id: <536C8E64.6000009@samsung.com>
Date: Fri, 09 May 2014 11:14:28 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        linux-security-module@vger.kernel.org, eparis@redhat.com,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: IMA + O_DIRECT (Re: [PATCH 0/1] fix IMA + Apparmor kernel panic)
References: <cover.1399554584.git.d.kasatkin@samsung.com>
 <29977.1399605003@jrobl>
In-reply-to: <29977.1399605003@jrobl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xy7oOfTnBBmv2qFt8WVpn8X9bC7vF
	xO1tLBbn+1rZLC7vmsNm8aHnEZvF+b/HWS0+rZjE7MDhsXPWXXaPB4c2s3i833eVzePzJjmP
	KYfaWTw2PXnLFMAWxWWTkpqTWZZapG+XwJWxasoc5oJF3BU/7k1ja2B8y9HFyMkhIWAi0fTn
	NjuELSZx4d56ti5GLg4hgaWMEpvugSRAnEYmiZ0TbrNCOLMYJX68mgOU4eDgFdCSuPA9CqSb
	RUBV4u+pZjYQm01AT2JD8w+wElGBCInHF4RAwrwCghI/Jt9jAQmLAHV2bwWbyCxwlFFi6vv5
	jCA1wgK+EpNnzWMCsYUEQiT+zLnMAmJzAo3/0NrFCmIzC+hI7G+dxgZhy0tsXvOWGaJeVaJ7
	7Vo2iGcUJU5PPsc8gVF4FpLVs5C0z0LSvoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZG
	SPx83cG49JjVIUYBDkYlHt4FMhnBQqyJZcWVuYcYJTiYlUR4PXpzgoV4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwdhz+/E+CkfH/u4mpmS3S5kucbl+yjA2+dbvJWyV88Zatei7SZp/OhZ+dWfLz
	2qodpV9WS7/fPVHGrFuGsYHX+QDX2f1t1aJKhz/8sxBeunXhpSq1A5K7pDl8jYW/h4Yv7lEy
	YdobuLLIwe3eiWqLd5bHIsJyraXZlfJ36KkbhmeuW7PuZc41JZbijERDLeai4kQAG0owKH0C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 06:10, J. R. Okajima wrote:
> Dmitry Kasatkin:
>> Following patch replaces IMA usage of kernel_read() with special
>> version which skips security check that triggers kernel panic
>> when Apparmor and IMA appraisal are enabled together.
> I know this is related to exit(2), but this behaviour of IMA is related
> to open(2) too.
> When O_DIRECT is specified, some filesystems (for example, ext2) call
> do_blockdev_direct_IO() which acquires i_mutex. But
> IMA:process_measurement() already acquires i_mutex before kernel_read().
> It causes a deadlock even if you replace kernel_read() by a simpler one.

Hi,

It is a different issue.

I made patch more than a year ago which fix the problem

https://lkml.org/lkml/2013/2/20/601

I think we had to declare the purpose of the patch in a bit different way.
IMA really does not need direct-io, and can temporarily drop the flag.
As side affect, it would fix the deadlock problem

But I have a different patch now. I will post it today.


> How can we stop reading the file from IMA?

It is actually very interesting question...

1) if you would like to use IMA without it reading a file, then I think
I must disappoint you.
It is not possible.. IMA needs reading a file.

2) if you do not use IMA, then there is no problem for you, because IMA
will not read file if it is not used...

Have a nice day.

- Dmitry

>
> J. R. Okajima
>


