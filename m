Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaLDM0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:26:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31310 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaLDM0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:26:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-2c-548053049509
Message-id: <5480529B.7010101@samsung.com>
Date: Thu, 04 Dec 2014 14:24:59 +0200
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] X.509: Extract both parts of the AuthorityKeyIdentifier
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
 <20141120165403.5264.18275.stgit@warthog.procyon.org.uk>
 <20141121144245.GA22306@redhat.com>
In-reply-to: <20141121144245.GA22306@redhat.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7oswQ0hButOMVq8a/rNYjF710MW
	i8u75rBZfOh5xGbRsu8Ck8XNaRdYLK7d2sdm8WnFJGYHDo9pJ5axeDw4tJnF4/2+q2weKzac
	YPY4s+AIu8fnTXIBbFFcNimpOZllqUX6dglcGXv2dbMVLOSsmL5pB1sD40n2LkZODgkBE4ld
	P6eyQNhiEhfurWfrYuTiEBJYyiix4NMEKKeRSeLZ8y3MEM4sRolPZyezgrTwCmhJbPl+Csxm
	EVCVOPf9KNgoNgE9iQ3NP8BWiApESFxZM4cRol5Q4sfke2A1IgIeEs9Of2MHGcossIRRYunB
	drBBwgIBEuv3dTDB3fFnxl4mkASngIHEp2k3gLo5gDr0JO5f1AIJMwvIS2xe85YZxBYCOqJ7
	7Vo2iH8UJU5PPsc8gVF4FpLdsxC6ZyHpXsDIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMj
	JIq+7GBcfMzqEKMAB6MSD++Cp/UhQqyJZcWVuYcYJTiYlUR4tXwbQoR4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwprUVmunX8M9e8W1twJW/4auu2QkaFP1kX8laYma0+NqZIDU9vWM+4fu99QPz
	Z24z7DC5tfnRg9WFsey7t27Y6Xm//0ZQJJOJ7d7CD52xTGveCAo/aNz+Mqz8Yb5bx97M+MDf
	ki95ugOTpG8x7GGt2FoyieH+k84jdXOtXIzm3vjz4cSPqKQMJZbijERDLeai4kQAhaN254AC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 16:42, Vivek Goyal wrote:
> On Thu, Nov 20, 2014 at 04:54:03PM +0000, David Howells wrote:
>
> [..]
>> diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
>> index 3dfe6b5d6f0b..223b72344060 100644
>> --- a/crypto/asymmetric_keys/x509_parser.h
>> +++ b/crypto/asymmetric_keys/x509_parser.h
>> @@ -21,7 +21,8 @@ struct x509_certificate {
>>  	char		*subject;		/* Name of certificate subject */
>>  	struct asymmetric_key_id *id;		/* Serial number + issuer */
>>  	struct asymmetric_key_id *skid;		/* Subject + subjectKeyId (optional) */
>> -	struct asymmetric_key_id *authority;	/* Authority key identifier (optional) */
>> +	struct asymmetric_key_id *auth_id;	/* CA AuthKeyId matching ->id (optional) */
>> +	struct asymmetric_key_id *auth_skid;	/* CA AuthKeyId matching ->skid (optional) */
> A very minor nit. It might help if we put additional comment to explain what
> auth_id and auth_skid are composed of (like other key ids).
>
> auth_id /* akid issuer + akid serial */
> auth_skid /* issuer + akid keyid */
>
> Thanks
> Vivek
>

Right,

David did not address this in his v2 patchset...

- Dmitry

