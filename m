Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaISPf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:35:57 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbaISPf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:35:56 -0400
Message-ID: <541C4D57.9050507@nod.at>
Date: Fri, 19 Sep 2014 17:35:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, sparse@chrisli.org
CC: Mark Rustad <mark.d.rustad@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 5/7] signal: Silence nested-externs warnings
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com> <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
In-Reply-To: <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.09.2014 17:29, schrieb Jeff Kirsher:
> From: Mark Rustad <mark.d.rustad@intel.com>
> 
> Silence nested-externs warnings for these, as these nested
> externs are truly wanted.
> 
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Richard Weinberger <richard@nod.at>
> CC: Brian Norris <computersforpeace@gmail.com>
> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  include/linux/signal.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index 750196f..e68ae6b 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -67,7 +67,9 @@ static inline int sigismember(sigset_t *set, int _sig)
>  
>  static inline int sigisemptyset(sigset_t *set)
>  {
> +	DIAG_PUSH DIAG_IGNORE(nested-externs)

Do we really want to clutter the source with such tags?
Does this even build? i.e. how does gcc know to ignore that?

rw@azrael:~/linux (ubi-wlcrash $)> git grep DIAG_PUSH | wc -l
0

Thanks,
//richard
