Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaJCMXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:23:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37664 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaJCMXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:23:25 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c8-542e953b18fe
Message-id: <542E953C.3010705@samsung.com>
Date: Fri, 03 Oct 2014 15:23:24 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, keyrings@linux-nfs.org, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        pjones@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH 08/13] KEYS: Overhaul key identification when searching for
 asymmetric keys
References: <542D741D.5070109@samsung.com>
 <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
 <20140908153830.28301.37880.stgit@warthog.procyon.org.uk>
 <28438.1412338372@warthog.procyon.org.uk>
In-reply-to: <28438.1412338372@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7rWU/VCDB5skLd41/SbxeLAuycs
	FrN3PWSxuLxrDpvFh55HbBZdC2+wW9ycdoHF4tqtfWwOHB7TTixj8Xi/7yqbx4oNJ5g9Pm+S
	C2CJ4rJJSc3JLEst0rdL4Mr4f3QOW8Fu7oqPF5ewNjBO4exi5OSQEDCRODP/ODuELSZx4d56
	ti5GLg4hgaWMEu0vzzKDJIQEGpkk9u2xgEjMYpTY2biRCSTBK6Al8WzVGjCbRUBV4vH3PrBJ
	bAJ6Ehuaf4DZogIREifv7mGHqBeU+DH5HguILSKgLvFo2UZmkKHMAlsYJRrWHmEDSQgLJEpM
	27ODCWLbOUaJs/O7WEESnAJmErM73jJ2MXIAdehJ3L+oBRJmFpCX2LzmLdSlqhLda9eyQbyj
	KHF68jnmCYzCs5DsnoXQPQtJ9wJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIfHyZQfj
	4mNWhxgFOBiVeHg/3tANEWJNLCuuzD3EKMHBrCTCK92kFyLEm5JYWZValB9fVJqTWnyIkYmD
	U6qBMWXhz7tfezb86s9OVVh9/Id51CmuP9pR+zO35fDvk0p59SK/U2iGhsDP7Y93m3fVzZja
	JZczecuED3H+JtUx1k/+Vr3aPqfqfxKf+6WtL182bat3nCdyw1Jkyamp5Sdc6hR4ZFOzTtVb
	TCruL+WTurvkiLNR5FpZ88qwNL5/D63ebxdXvl/gosRSnJFoqMVcVJwIAPyJEFV1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/14 15:12, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> Also I noticed that output of 'keyctl show' and 'cat /proc/keys' output
>> also has changed in respect of certificate ids..
>>
>> Those ids does not look any close to my kernel X509 X509v3 Subject Key
>> Identifier, which is:
>> 92:63:05:D6:DD:A6:6F:47:13:9E:B4:E3:CB:25:A6:AD:EF:52:7F:08
>>
>> proc/keys shows
>>
>> symmetri Magrathea: Glacier signing key: d9e2e4c6951f1e83: X509.RSA
>> 6865612e68326732 []
>>
>> Very different ids..
>>
>> How could I match certificate now?
> There are two IDs available:
>
> 	id: serial number + issuer
> 	skid: subjKeyId + subject
>
> You can use either of them and their content is somewhat negotiable.  Note
> that they are both compound IDs at this point.
>
> We have to move away from using subjKeyId for module signatures because we
> have to be able to deal with keys that don't have one.  Blech, but the PKCS
> specs suck somewhat.
>
> This is why I want to move to using detached-data PKCS#7 certs as the
> signature.  We have the PKCS#7 handling in the kernel now for doing kexec.

I looked to the code and understood...

See my patches please.

- Dmitry

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

