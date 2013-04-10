Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937008Ab3DJQNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:13:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:10918 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3DJQNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="225595524"
Message-ID: <51659024.4010405@intel.com>
Date: Wed, 10 Apr 2013 09:15:32 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: dhowells@redhat.com, linux-kernel@vger.kernel.org, mark.gross@intel.com
Subject: Re: [PATCH v2] MODSIGN: do not send garbage to stderr when enabling
 modules signature
References: <1365543543-17522-1-git-send-email-david.a.cohen@intel.com> <87k3oa65hx.fsf@rustcorp.com.au>
In-Reply-To: <87k3oa65hx.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 03:32 AM, Rusty Russell wrote:
> David Cohen <david.a.cohen@intel.com> writes:
>> openssl may send garbage to stderr when generating X.509 key pair for
>> modules signature regardless there was an error or not. It makes more
>> difficult to create scripts based on kernel error/warning messages.
>>
>> When compiling kernel with -jN (N > 1), all warning/error messages
>> printed while openssl is generating key pair may get mixed dots and
>> other symbols openssl sends to stderr. This patch makes sure openssl
>> logs go to default stdout.
> Ah!  Not garbage, but it writes progress dots and status messages to
> stderr?
>
> I trimmed your commit message as shown below.

Thanks! The new commit message looks fine.
But it's not the dots. It prints the whole logs to stderr, but the dots 
are more likely to get mixed.

Br, David

>
> Thanks!
> Rusty.
>
> From: David Cohen <david.a.cohen@intel.com>
> Subject: MODSIGN: do not send garbage to stderr when enabling modules signature
>
> When compiling kernel with -jN (N > 1), all warning/error messages
> printed while openssl is generating key pair may get mixed dots and
> other symbols openssl sends to stderr. This patch makes sure openssl
> logs go to default stdout.
>
> Example of the garbage on stderr:
>
> crypto/anubis.c:581: warning: ‘inter’ is used uninitialized in this function
> Generating a 4096 bit RSA private key
> .........
> drivers/gpu/drm/i915/i915_gem_gtt.c: In function ‘gen6_ggtt_insert_entries’:
> drivers/gpu/drm/i915/i915_gem_gtt.c:440: warning: ‘addr’ may be used uninitialized in this function
> .net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
> net/mac80211/tx.c:1780: warning: ‘chanctx_conf’ may be used uninitialized in this function
> ..drivers/isdn/hardware/mISDN/hfcpci.c: In function ‘hfcpci_softirq’:
> .....drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: ignoring return value of ‘driver_for_each_device’, declared with attribute warn_unused_result
>
> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Reviewed-by: mark gross <mark.gross@intel.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>   kernel/Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index bbde5f1..5a51e6c 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.genkey
>   	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 \
>   		-batch -x509 -config x509.genkey \
>   		-outform DER -out signing_key.x509 \
> -		-keyout signing_key.priv
> +		-keyout signing_key.priv 2>&1
>   	@echo "###"
>   	@echo "### Key pair generated."
>   	@echo "###"
>

