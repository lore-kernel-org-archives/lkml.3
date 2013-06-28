Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3F1Pow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:44:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39709 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964Ab3F1Pou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:44:50 -0400
Message-ID: <1372434289.29380.6.camel@joe-AO722>
Subject: Re: [PATCH net-next v3 1/2] lib: vsprintf: add IPv4/v6 generic
 %p[Ii]S[pfs] format specifier
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 08:44:49 -0700
In-Reply-To: <1372421131-1672-2-git-send-email-dborkman@redhat.com>
References: <1372421131-1672-1-git-send-email-dborkman@redhat.com>
	 <1372421131-1672-2-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 14:05 +0200, Daniel Borkmann wrote:
> In order to avoid making code that deals with printing both, IPv4 and
> IPv6 addresses, unnecessary complicated as for example ...

Thanks Daniel, seems sensible.  Just trivial comments...

[]

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]

Should any other include other than net/addrconf be needed?

> +char *ip6_addr_string_sa(char *buf, char *end, const struct sockaddr_in6 *sa,
> +			 struct printf_spec spec, const char *fmt)
> +{
[]
> +	char fmt6[2] = { fmt[0], '6'};

This looks odd to me.  why not use a bool compressed
flag and identify this before the isalpha loop and not
have fmt6 at all?

> +	u8 off = 0;
> +
> +	fmt++;
> +	while (isalpha(*++fmt)) {
> +		switch (*fmt) {
> +		case 'p':
> +			have_p = true;
> +			break;
> +		case 'f':
> +			have_f = true;
> +			break;
> +		case 's':
> +			have_s = true;
> +			break;
> +		case 'c':
> +			have_c = true;
> +			break;
> +		}
> +	}


