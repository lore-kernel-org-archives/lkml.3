Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaHLERi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 00:17:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42841 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaHLERg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 00:17:36 -0400
Date: Mon, 11 Aug 2014 21:17:33 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u/ieee80211: Fix sparse
 ieee80211_debug_init/_exit not declared warning
Message-ID: <20140812041733.GA7613@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Joel Pelaez Jorge <joelpelaez@gmail.com>,
	linux-kernel@vger.kernel.org
References: <1407795354-1700-1-git-send-email-jmmahler@gmail.com>
 <20140811223206.GB9475@kroah.com>
 <53E985D1.9050503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53E985D1.9050503@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:11:13PM -0500, Joel Pelaez Jorge wrote:
> El 11/08/14 a las 17:32, Greg Kroah-Hartman escibió:
> > On Mon, Aug 11, 2014 at 03:15:54PM -0700, Jeremiah Mahler wrote:
> >> A sparse warning is generated about 'ieee80211_debug_init' and
> >> 'ieee80211_debug_exit' not being declared.
> >>
> >>   drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:275:12: warning:
> >>   symbol 'ieee80211_debug_init' was not declared. Should it be static?
> >>   drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:297:13: warning:
> >>   symbol 'ieee80211_debug_exit' was not declared. Should it be static?
> >>
> >> These functions are used outside of this file so using static will not
> >> work.  Fix the warning by declaring the functions in the header file,
> >> ieee80211.h
> >>
> >> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Teodora Baluta <teobaluta@gmail.com>
> >> Cc: Andrea Merello <andrea.merello@gmail.com>
> >> Cc: Joel Pelaez Jorge <joelpelaez@gmail.com>
> >> Cc: Bob Copeland <me@bobcopeland.com>
> >> Cc: Joe Perches <joe@perches.com>
> >> Cc: Arnd Bergmann <arnd@arndb.de>
> >> Cc: Himangi Saraogi <himangi774@gmail.com>
> >> ---
> >>  drivers/staging/rtl8192u/ieee80211/ieee80211.h | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> >> index 1040bab..9cbda69 100644
> >> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> >> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
> >> @@ -2485,6 +2485,12 @@ extern int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_reques
> >>  extern int ieee80211_wx_get_freq(struct ieee80211_device *ieee, struct iw_request_info *a,
> >>  			     union iwreq_data *wrqu, char *b);
> >>  
> >> +/* ieee80211_module.c */
> >> +#ifdef CONFIG_IEEE80211_DEBUG
> >> +extern int __init ieee80211_debug_init(void);
> >> +extern void __exit ieee80211_debug_exit(void);
> >> +#endif /* CONFIG_IEEE80211_DEBUG */
> >> +
> > 
> > As it's a header file, why not always have them here, no need for the
> > ifdef.
> > 
> > And __init and __exit don't belong in a .h function prototype.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> The symbol ieee80211_debug_init(void) and ieee80211_debug_exit(void) are declared as prototype in r8192U_core.c, this cause a double function prototype. It is only a comment, it not affect anything. Check it to next time.
> 
> 	- Joel

Thanks for the information Joel.  While my patch does fix the sparse
warning, having two duplicate function prototypes seems suboptimal as
well.  I will see if I can find a better way to fix this warning.

-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
