Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947274Ab3BHWWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:22:39 -0500
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:44988 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947059Ab3BHWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:22:37 -0500
X-Greylist: delayed 4021 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 17:22:37 EST
Message-ID: <51156A91.5070801@cantab.net>
Date: Fri, 08 Feb 2013 21:13:53 +0000
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1360355677-52442-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1360355677-52442-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: dvrabel@cantab.net
Subject: Re: [Xen-devel] [PATCH linux-next] xen/multicall: xen_mc_callback():
 avoid buffer overflow
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on pear)
X-Originating-Smarthost03-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 20:34, Tim Gardner wrote:
> This buffer overflow was introduced with 91e0c5f3dad47838cb2ecc1865ce789a0b7182b1
> (2.6.24).

There's no buffer overflow here. xen_mc_flush() resets b->cbidx.

David

>  arch/x86/xen/multicalls.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
> index 0d82003..5270407 100644
> --- a/arch/x86/xen/multicalls.c
> +++ b/arch/x86/xen/multicalls.c
> @@ -195,9 +195,10 @@ void xen_mc_callback(void (*fn)(void *), void *data)
>  	struct mc_buffer *b = &__get_cpu_var(mc_buffer);
>  	struct callback *cb;
>  
> -	if (b->cbidx == MC_BATCH) {
> +	if (b->cbidx >= MC_BATCH) {
>  		trace_xen_mc_flush_reason(XEN_MC_FL_CALLBACK);
>  		xen_mc_flush();
> +		return;
>  	}
>  
>  	trace_xen_mc_callback(fn, data);
> 

