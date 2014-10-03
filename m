Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbaJCXgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:36:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:37065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbaJCXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:36:49 -0400
Message-ID: <542F3304.4000703@infradead.org>
Date: Fri, 03 Oct 2014 16:36:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?UTF-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Tejun Heo <tj@kernel.org>, Fabian Frederick <fabf@skynet.be>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break
 up the EXPERT menu
References: <20141003233139.GA16079@thin>
In-Reply-To: <20141003233139.GA16079@thin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 16:31, Josh Triplett wrote:
> commit 03b8c7b623c80af264c4c8d6111e5c6289933666 ("futex: Allow
> architectures to skip futex_atomic_cmpxchg_inatomic() test") added the
> HAVE_FUTEX_CMPXCHG symbol right below FUTEX.  This placed it right in
> the middle of the options for the EXPERT menu.  However,
> HAVE_FUTEX_CMPXCHG does not depend on EXPERT or FUTEX, so Kconfig stops
> placing items in the EXPERT menu, and displays the remaining several
> EXPERT items (starting with EPOLL) directly in the General Setup menu.
> 
> Since both users of HAVE_FUTEX_CMPXCHG only select it "if FUTEX", make
> HAVE_FUTEX_CMPXCHG itself depend on FUTEX.  With this change, the
> subsequent items display as part of the EXPERT menu again; the EMBEDDED
> menu now appears as the next top-level item in the General Setup menu,
> which makes General Setup much shorter and more usable.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Posting for review.  I can upstream this through the tiny tree.
> 
> Personally, I'd consider this a bit of a bug in Kconfig; ideally,
> Kconfig should only consider symbols with prompt strings when
> considering what to display in a menu.  However, in the interim, this
> one-line patch drastically improves the usability of the "General Setup"
> config menu.

Good catch.  Thanks.

I would prefer to see both of your patches merged quickly into 3.17 no matter
how they get there.

both patches:
Acked-by: Randy Dunlap <rdunlap@infradead.org>


>  init/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 31505a5..80a6907 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1477,6 +1477,7 @@ config FUTEX
>  
>  config HAVE_FUTEX_CMPXCHG
>  	bool
> +	depends on FUTEX
>  	help
>  	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
>  	  is implemented and always working. This removes a couple of runtime
> 


-- 
~Randy
