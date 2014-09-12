Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaILULV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:11:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41038 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaILULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:11:20 -0400
Message-ID: <1410552676.5187.211.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Keyrings] [PATCH 1/9] Provide a binary to hex conversion
 function
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: vgoyal@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 16:11:16 -0400
In-Reply-To: <20140912190515.13239.89507.stgit@warthog.procyon.org.uk>
References: <20140912190510.13239.90409.stgit@warthog.procyon.org.uk>
	 <20140912190515.13239.89507.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091220-9332-0000-0000-000002003EB5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 20:05 +0100, David Howells wrote: 
> Provide a function to convert a buffer of binary data into an unterminated
> ascii hex string representation of that data.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/kernel.h |    1 +
>  lib/hexdump.c          |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 95624bed87ef..7c0ad8e38510 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -496,6 +496,7 @@ static inline char *hex_byte_pack_upper(char *buf, u8 byte)
> 
>  extern int hex_to_bin(char ch);
>  extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
> +extern char *bin2hex(char *dst, const void *src, size_t count);
> 
>  bool mac_pton(const char *s, u8 *mac);
> 
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index 8499c810909a..6daf254dddfa 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -59,6 +59,24 @@ int hex2bin(u8 *dst, const char *src, size_t count)
>  EXPORT_SYMBOL(hex2bin);
> 
>  /**
> + * bin2hex - convert binary data to an ascii hexadecimal string
> + * @dst: ascii hexadecimal result
> + * @src: binary data
> + * @count: binary data length
> + */
> +char *bin2hex(char *dst, const void *src, size_t count)
> +{
> +	while (count--) {
> +		unsigned char ch = *(const unsigned char *)src;
> +		*dst++ = hex_asc[ch >> 4];
> +		*dst++ = hex_asc[ch & 0xf];
> +		src++;

How about using hex_byte_pack()?

Mimi

> +	}
> +	return dst;
> +}
> +EXPORT_SYMBOL(bin2hex);

> +
> +/**
>   * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
>   * @buf: data blob to dump
>   * @len: number of bytes in the @buf
> 
> _______________________________________________
> Keyrings mailing list
> Keyrings@linux-nfs.org
> To change your subscription to this list, please see http://linux-nfs.org/cgi-bin/mailman/listinfo/keyrings
> 


