Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937327Ab3DIJzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:55:54 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32396 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935402Ab3DIJzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:55:42 -0400
X-Spam-Score: -100.7
Message-ID: <5163E57E.5030705@asianux.com>
Date: Tue, 09 Apr 2013 17:55:10 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead
 of strncpy
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com> <8738v19lv0.fsf@rustcorp.com.au> <51637441.2090006@asianux.com> <5163E123.5080205@asianux.com>
In-Reply-To: <5163E123.5080205@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月09日 17:36, Chen Gang wrote:
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 487ac6f..9ec6d1f 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -145,13 +145,15 @@ static int read_symbol(FILE *in, struct sym_entry *s)
>  	/* include the type field in the symbol name, so that it gets
>  	 * compressed together */
>  	s->len = strlen(str) + 1;
> +	if (s->len > KSYM_NAME_LEN)
> +		s->len = KSYM_NAME_LEN;
>  	s->sym = malloc(s->len + 1);
>  	if (!s->sym) {
>  		fprintf(stderr, "kallsyms failure: "
>  			"unable to allocate required amount of memory\n");
>  		exit(EXIT_FAILURE);
>  	}
> -	strcpy((char *)s->sym + 1, str);
> +	strlcpy((char *)s->sym + 1, str, KSYM_NAME_LEN);
>  	s->sym[0] = stype;
>  

  oh... it is a user mode program which no strlcpy in lib C !!

  (so this diff is just really for a reference, not for the real using)

  :-)

-- 
Chen Gang

Asianux Corporation
