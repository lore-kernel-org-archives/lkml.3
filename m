Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaJCOAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:00:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42768 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaJCOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:00:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-01-542eabe2939d
Message-id: <542EABE4.9000101@samsung.com>
Date: Fri, 03 Oct 2014 17:00:04 +0300
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
References: <542E9FE8.2070009@samsung.com>
 <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com>
 <542E9C65.4030208@samsung.com> <13201.1412343605@warthog.procyon.org.uk>
In-reply-to: <13201.1412343605@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xa7qPVuuFGCy/ImLxruk3i8WXpXUW
	69YvZrKYveshi8XLGfPYLS7vmsNm8aHnEZvFzWkXWCw+rZjE7MDpsXPWXXaPaSeWsXg8OLSZ
	xWP3gs9MHj3fkz3e77vK5rFiwwlmj8+b5AI4orhsUlJzMstSi/TtErgytk/fwlLwlr3iwrEt
	bA2MU9i6GDk5JARMJNZP3MMOYYtJXLi3HijOxSEksJRR4mL7PBYIp5FJ4vWaz4wgVUICsxgl
	dtxJB7F5BbQkVr5fCDaJRUBVYseln2A1bAJ6Ehuaf4BNFRWIkDh5F2IDr4CgxI/J91hAbBEB
	dYlHyzYygyxgFnjNKLHxygdWkISwgK3Ek66DUGd8ZpJYPGEFWDengJnEy7vnmboYOYA69CTu
	X9QCCTMLyEtsXvOWGeI4VYnutWuhXlOUOD35HPMERuFZSHbPQuiehaR7ASPzKkbR1NLkguKk
	9FxDveLE3OLSvHS95PzcTYyQ6Pqyg3HxMatDjAIcjEo8vB9v6IYIsSaWFVfmHmKU4GBWEuFd
	sFIvRIg3JbGyKrUoP76oNCe1+BAjEwenVAPjap37y3++Mks19uF9/czVQy6Y/W7T2ZYX53Zt
	CXd0ubGNOybubFfZptnyNwPkm7V8vCVid+kvKbud/Xd7mPjlh0f+T3r7LbYg/cSB2i0/PWsK
	ZbiTKxifvXKJUBessita5i/Pxv+9Q3zuhSkvPpvcSe8pFdR8cneeQpTM5MgUTtWd/lpC+1OU
	WIozEg21mIuKEwHA3lAkjAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 16:40, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> BTW. But actually why signer is needed to find the key?
>> Every key has unique fingerprint.
> The SKID is by no means guaranteed unique, is not mandatory and has no defined
> algorithm for generating it.

SKID is unique. SKID == SHA1(PK)

I understand that it may be missing for someone. But if it presents in
the certificate it should not be a problem...

>> Or you say that different certificates might have the same PK?
>> What I would consider strange. But anyway, if PK is the same, then
>> verification succeed.
> Do note: We *do* need to get away from using SKIDs.  We have situations where
> we have to use a key that doesn't have one.
>
> David

I understand that... What I claim is that if there is a SKID, it is
unique and enough to identify certificate in the keyring...

Integrity subsystem uses partial SKID and it MUST NOT be broken for
compatibility.


Dmitry


