Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaJCNJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:09:01 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36139 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:08:58 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-89-542e9fe67317
Message-id: <542E9FE8.2070009@samsung.com>
Date: Fri, 03 Oct 2014 16:08:56 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 3/4] module: search the key only by keyid
References: <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com>
 <542E9C65.4030208@samsung.com>
In-reply-to: <542E9C65.4030208@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xq7rP5uuFGKz+rGzxruk3i8WXpXUW
	69YvZrKYveshi8XLGfPYLS7vmsNm8aHnEZvFzWkXWCw+rZjE7MDpsXPWXXaPaSeWsXg8OLSZ
	xWP3gs9MHj3fkz3e77vK5rFiwwlmj8+b5AI4orhsUlJzMstSi/TtErgybjedYSq4yFmx9fZJ
	9gbG1+xdjJwcEgImErMn3GSCsMUkLtxbz9bFyMUhJLCUUeLU24csEE4jk8TGvrOMEM4sRom5
	Z3aCtfMKaEkcap0L1s4ioCrRsH87mM0moCexofkHWI2oQITEybt7oOoFJX5MvscCYosIqEs8
	WraRGWQos8BrRomNVz6wgiSEBWwlnnQdhLpjFZPE/XVTwTo4BbQlDvWvBLI5gDr0JO5f1AIJ
	MwvIS2xe85YZxBYCOqJ77Vo2iH8UJU5PPsc8gVF4FpLdsxC6ZyHpXsDIvIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJL6+7mBceszqEKMAB6MSD++HG7ohQqyJZcWVuYcYJTiYlUR4pZv0
	QoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwCqxV6azawb/nXd0j5Y9zxS0Ob3TeGxwUXf/pMOvn
	Y6c1w8+Lz+fx5ll/9tzUf8qse8UvPr9UWxU0PSUytjzz2Iy6a9lOZn78/D0/ZR1bW9Lf7hQ7
	uHLSzFUzi5L+fTH5eyUm8kfbEaWt1h513zWevG8vzlNYcW9LXd038eyMBYvlZmmFH37cqMRS
	nJFoqMVcVJwIALaWZ0qNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:53, Dmitry Kasatkin wrote:
> On 03/10/14 15:49, Dmitry Kasatkin wrote:
>> On 03/10/14 15:46, David Howells wrote:
>>> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>>>
>>>> Latest KEYS code change the way keys identified and module
>>>> signing keys are not searchable anymore with original id.
>>>>
>>>> This patch fixes this problem without change module signature
>>>> data.
>>> This isn't sufficient.  The key search must also include the signer.

BTW. But actually why signer is needed to find the key?
Every key has unique fingerprint.

Or you say that different certificates might have the same PK?
What I would consider strange. But anyway, if PK is the same, then
verification succeed.

- Dmitry

>> IMA uses "id:<id>" partial matching.. There is no signer in the signature.
>> It is added as "last resort"
>>
>> It is here... the same but I renamed with finger print..
>>
>> http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/commit/?h=keys-fixes&id=f036bb9a4c1b3c548f315226d3284e6a91d284e7
>>
>> - Dmitry
>>
>>
> For module actually I made it as a fix because it was broken.
> Other requires changes in module signature format...
>
> - Dmitry
>
>

