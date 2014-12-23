Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbaLWNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:31:17 -0500
Received: from mail.us.es ([193.147.175.20]:34657 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbaLWNbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:31:15 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus1 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19827. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-103.2/7.5):. 
 Processed in 5.601909 secs); 23 Dec 2014 13:31:14 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Tue, 23 Dec 2014 14:33:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] netfilter: remove unnecessary sizeof(char)
Message-ID: <20141223133338.GA15456@salvia>
References: <1419273375-24312-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419273375-24312-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 07:36:15PM +0100, Fabian Frederick wrote:
> sizeof(char) is always 1.

Applied, thanks.

Made a small change on it:

> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  net/netfilter/nf_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 43c926c..1191f66 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -426,7 +426,7 @@ static int netfilter_log_sysctl_init(struct net *net)
>  				nf_log_sysctl_fnames[i];
>  			nf_log_sysctl_table[i].data = NULL;
>  			nf_log_sysctl_table[i].maxlen =
> -				NFLOGGER_NAME_LEN * sizeof(char);
> +				NFLOGGER_NAME_LEN;

this now fits in one line (80-chars).

>  			nf_log_sysctl_table[i].mode = 0644;
>  			nf_log_sysctl_table[i].proc_handler =
>  				nf_log_proc_dostring;
> -- 
> 1.9.1
> 
