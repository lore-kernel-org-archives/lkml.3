Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaKEXVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:21:34 -0500
Received: from mail.us.es ([193.147.175.20]:52081 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaKEXVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:21:31 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus4 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.4/19591. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 4.252613 secs); 05 Nov 2014 23:21:29 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Thu, 6 Nov 2014 00:23:14 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 3/8] netfilter: Convert print_tuple functions to return
 void
Message-ID: <20141105232314.GA3195@salvia>
References: <20141105192426.348510548@goodmis.org>
 <20141105192544.214361386@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105192544.214361386@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 02:24:29PM -0500, Steven Rostedt wrote:
> From: Joe Perches <joe@perches.com>
> 
> Since adding a new function to seq_file (seq_has_overflowed())
> there isn't any value for functions called from seq_show to
> return anything.   Remove the int returns of the various
> print_tuple/<foo>_print_tuple functions.
> 
> Link: http://lkml.kernel.org/p/f2e8cf8df433a197daa62cbaf124c900c708edc7.1412031505.git.joe@perches.com
> 
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I replied to this yesterday, but it seems some spam filter also
munched it. One comment below.

> @@ -202,9 +203,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  	if (l4proto->print_conntrack)
>  		l4proto->print_conntrack(s, ct);
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> -			l3proto, l4proto))
> -		goto release;
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
> +		    l3proto, l4proto);
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
>  		goto release;

seq_print_acct returns seq_printf which is now void. I guess you have
to remove this check too.

> @@ -213,9 +213,8 @@ static int ct_seq_show(struct seq_file *s, void *v)
>  		if (seq_printf(s, "[UNREPLIED] "))
>  			goto release;
>  
> -	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> -			l3proto, l4proto))
> -		goto release;
> +	print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
> +		    l3proto, l4proto);
>  
>  	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
>  		goto release;

And here.
