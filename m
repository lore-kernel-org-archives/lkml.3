Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaJTLMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:12:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52225 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaJTLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:12:29 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-46-5444ee1a38e9
Message-id: <5444EE01.6030005@samsung.com>
Date: Mon, 20 Oct 2014 14:12:01 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH 0/3] MODSIGN: Use PKCS#7 cert to avoid SKIDs
References: <5432A4F1.4040507@samsung.com>
 <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
 <1893.1413462701@warthog.procyon.org.uk>
In-reply-to: <1893.1413462701@warthog.procyon.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7pS71xCDH7NFrN41/SbxeLL0jqL
	2bseslhc3jWHzeJDzyM2i5vTLrBYfFoxidmB3WPnrLvsHtNOLGPxeHBoM4vH+31X2TxWbDjB
	7PF5k1wAWxSXTUpqTmZZapG+XQJXxoVra5gKDrFV/D6wgL2BcQ9rFyMnh4SAicSmFycZIWwx
	iQv31rOB2EICSxklXp/x6mLkArIbmSSOff3NCuHMYpT43fOEGaSKV0BL4mL/PLBuFgFViddf
	noBNZRPQk9jQ/IMdxBYViJC4smYOI0S9oMSPyfdYQGwRAXWJR8s2MoMMZRa4wCix7e5CsAZh
	AQeJ63O62SG2TWSU2NN8DWwbp4CpxL+uK0AbOIA69CTuX9QCCTMLyEtsXvOWGeJsVYnutWvZ
	IN5RlDg9+RzzBEbhWUh2z0LonoWkewEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLj5
	uoNx6TGrQ4wCHIxKPLw7zFxChFgTy4orcw8xSnAwK4nwOrwBCvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamBsrjA1Dzz26Fyixx8u8y/SMu9ahWd+WXlc5EypVZbX8WnW7vsCHje8lv10Sslx0av8
	8IPe8rV8G0vaq4s/WZ6LMEz53/Dg8q0EoV+VGsUBXpfSAtQ3f+H71jkn8Ja7uh4H89k5l3Xl
	dDptqjOPMtkf2iXaoVW0oVuxOmrKnKtHDPXWbJwoaq/EUpyRaKjFXFScCAA/O4/YeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 15:31, David Howells wrote:
> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> /tmp/ccgSFKJd.o: In function `display_openssl_errors':
>> sign-file.c:(.text+0x4e): undefined reference to `ERR_peek_error'
>> sign-file.c:(.text+0xa1): undefined reference to `ERR_error_string'
>> ...
> Is this solved for you by making the attached change?
>
> David
> ---
>
> diff --git a/scripts/Makefile b/scripts/Makefile
> index 1d9c40be606e..719311b7bd46 100644
> --- a/scripts/Makefile
> +++ b/scripts/Makefile
> @@ -20,7 +20,7 @@ hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
>  
>  HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
>  HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
> -HOSTCFLAGS_sign-file.o = -lcrypto
> +HOSTLOADLIBES_sign-file = -lcrypto
>

Hi,

Yes. It helps...

- Dmitry

