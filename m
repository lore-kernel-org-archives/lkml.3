Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaF3NPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:15:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25164 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaF3NPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:15:43 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e6-53b162fc254e
Message-id: <53B162C2.3070800@samsung.com>
Date: Mon, 30 Jun 2014 16:14:42 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 3/6] KEYS: make partial key id matching as a dedicated
 function
References: <1403620852-16476-4-git-send-email-zohar@linux.vnet.ibm.com>
 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
 <7564.1403876287@warthog.procyon.org.uk>
In-reply-to: <7564.1403876287@warthog.procyon.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7p/kjYGGyy6bWjxruk3i8WXpXUW
	B949YbGYveshi8XlXXPYLD70PGKzuPpwNovFpxWTmB04PHbOusvuMe3EMhaPB4c2s3i833eV
	zWPdja/sHp83yQWwRXHZpKTmZJalFunbJXBl9D6+wFSwh71izuU9LA2Mv1i7GDk5JARMJA51
	NLBA2GISF+6tZ+ti5OIQEljKKPF05UcWCKeRSaLp+AcmCGcWo8SL6S/B2nkFtCS23drLDmKz
	CKhKHJx6iBnEZhPQk9jQ/AMsLioQIXGg7xlUvaDEj8n3wNaJCPhJ3OjZxAhiMwv0MUnc2SQK
	YgsD1R9tvw91xiZGiV/bz4IN4hQwldi/4R4rRIOOxP7WaWwQtrzE5jVvwRYLAR3RvXYtG8Q/
	ihKnJ59jnsAoPAvJ7llI2mchaV/AyLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIySKvu5g
	XHrM6hCjAAejEg+vxZYNwUKsiWXFlbmHGCU4mJVEeG/6bAwW4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwBhUtKntx4fgtER23sey6t9fKs8/c7L62LSwO1ese5Y9bPZbPNPrI/ubkwahcyximDPv
	ztEKiFDMWvDq3eOV/d82S9uwuPvKFXkkOgVozTeP6+5Se3HxJDvrLH/WVT7+ysaZNWU9AsLf
	NP51l5R5uTx94f/D/VnI3B2Xi0WYKk8sM2Yyn33khBJLcUaioRZzUXEiAEc/8oSAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 16:38, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>> +	if (strncmp(id, "id:", 3) == 0)

>> Use memcmp() here.

'id' function parameter comes from "keys_ownerid" kernel parameter.
User can supply anything shorter than "id:".
Though comparing 3 bytes should not produce any memory access errors,
memcmp can access beyond the length of the string.
I think 'strcnmp' is more appropriate here...


>> -	kid += kidlen - idlen;
>> -	if (strcasecmp(id, kid) != 0)
>> -		return 0;
> This test is no longer applied in the "<subtype>:..." case.

I did not get fully what you comment here or ask to do..
But yes, with this patch, it is no longer the case.

Thanks,
Dmitry

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

