Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaBFVdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaBFVdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:33:52 -0500
Message-ID: <52F3FFBC.1010505@redhat.com>
Date: Thu, 06 Feb 2014 16:33:48 -0500
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Moskyto Matejka <mq@suse.cz>, "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inet: defines IPPROTO_* needed for module alias generation
References: <1391685000-7346-1-git-send-email-mq@suse.cz>
In-Reply-To: <1391685000-7346-1-git-send-email-mq@suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 06:10 AM, Jan Moskyto Matejka wrote:
> Commit cfd280c91253 ("net: sync some IP headers with glibc") changed a set of
> define's to an enum (with no explanation why) which introduced a bug
> in module mip6 where aliases are generated using the IPPROTO_* defines;
> mip6 doesn't load if require_module called with the aliases from
> xfrm_get_type().

I wrote that code and I apologize for not giving a reason at
the time.

There are two reasons:

* It makes the debuginfo better and debugging easier via the enum.

* It harmonizes those headers with what is already in glibc.

Harmonizing this header with glibc makes it easier for userspace
to synchronize changes and perhaps eventually use the UAPI headers
directly.

> Reverting this change back to define's to fix the aliases.
> 
> modinfo mip6 (before this change)
> alias:          xfrm-type-10-IPPROTO_DSTOPTS
> alias:          xfrm-type-10-IPPROTO_ROUTING
> 
> modinfo mip6 (after this change)
> alias:          xfrm-type-10-43
> alias:          xfrm-type-10-60

Instead of reverting these changes I suggest someone fix
whatever is processing that information.

I do not condone the application of this patch for the
above two reasons. Though you might argue that I should
just make all debuggers and compilers better at dealing
with DW_at_macro_info/DW_MACINFO_* debug info... and 
you also would not be wrong.

I hope that answers your question.

> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> ---
>  include/uapi/linux/in6.h | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> index 633b93c..e9a1d2d97 100644
> --- a/include/uapi/linux/in6.h
> +++ b/include/uapi/linux/in6.h
> @@ -128,22 +128,13 @@ struct in6_flowlabel_req {
>   *	IPV6 extension headers
>   */
>  #if __UAPI_DEF_IPPROTO_V6
> -enum {
> -  IPPROTO_HOPOPTS = 0,		/* IPv6 hop-by-hop options      */
> -#define IPPROTO_HOPOPTS		IPPROTO_HOPOPTS
> -  IPPROTO_ROUTING = 43,		/* IPv6 routing header          */
> -#define IPPROTO_ROUTING		IPPROTO_ROUTING
> -  IPPROTO_FRAGMENT = 44,	/* IPv6 fragmentation header    */
> -#define IPPROTO_FRAGMENT	IPPROTO_FRAGMENT
> -  IPPROTO_ICMPV6 = 58,		/* ICMPv6                       */
> -#define IPPROTO_ICMPV6		IPPROTO_ICMPV6
> -  IPPROTO_NONE = 59,		/* IPv6 no next header          */
> -#define IPPROTO_NONE		IPPROTO_NONE
> -  IPPROTO_DSTOPTS = 60,		/* IPv6 destination options     */
> -#define IPPROTO_DSTOPTS		IPPROTO_DSTOPTS
> -  IPPROTO_MH = 135,		/* IPv6 mobility header         */
> -#define IPPROTO_MH		IPPROTO_MH
> -};
> +#define IPPROTO_HOPOPTS		0	/* IPv6 hop-by-hop options	*/
> +#define IPPROTO_ROUTING		43	/* IPv6 routing header		*/
> +#define IPPROTO_FRAGMENT	44	/* IPv6 fragmentation header	*/
> +#define IPPROTO_ICMPV6		58	/* ICMPv6			*/
> +#define IPPROTO_NONE		59	/* IPv6 no next header		*/
> +#define IPPROTO_DSTOPTS		60	/* IPv6 destination options	*/
> +#define IPPROTO_MH		135	/* IPv6 mobility header		*/
>  #endif /* __UAPI_DEF_IPPROTO_V6 */
>  
>  /*
> 

Cheers,
Carlos.
