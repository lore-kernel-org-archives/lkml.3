Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbaGQP72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:59:28 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:54657 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757263AbaGQP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:59:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:69:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2895:2907:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4425:4605:5007:6117:6119:7652:7875:7903:9025:9072:9388:10004:10049:10400:10848:11026:11232:11658:11914:12043:12291:12296:12517:12519:12683:12740:13019:13138:13231:13618:14094:14095:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:
X-HE-Tag: humor04_6ee8dc5954b02
X-Filterd-Recvd-Size: 3796
Message-ID: <1405612760.12363.14.camel@joe-AO725>
Subject: Re: [PATCH v2 0/6] printk: start simplifying some flags
From: Joe Perches <joe@perches.com>
To: Alex Elder <elder@linaro.org>, Kay Sievers <kay@vrfy.org>
Cc: akpm@linux-foundation.org, pmladek@suse.cz, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 08:59:20 -0700
In-Reply-To: <1405606151-19875-1-git-send-email-elder@linaro.org>
References: <1405606151-19875-1-git-send-email-elder@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again adding Kay Sievers.

Kay wrote almost all of this originally and should
be able to review it.

Alex, if this series is resubmitted, do please cc Kay.

It does seem reasonable to me, thanks for doing it.

On Thu, 2014-07-17 at 09:09 -0500, Alex Elder wrote:
> Each log record has a "flags" field.  The flags keep track of, for
> instance, whether the record was saved in its entirety (as opposed
> to being one of multiple records that should be merged as a single
> unit).  A log record's flags field alone is not currently sufficient
> to know how the record should be formatted; you need to know the
> previous record's flags field as well.  I found understanding the
> real effect of various combinations of these flags to be very
> difficult, and was moved to try to do something about that.
> 
> This series includes three patches that begin the process of
> simplifying how these flags are used and interpreted.  They include
> very long, detailed explanations (as small patches often do) because
> I want my reasoning to be very clear and examined very closely.  I
> really don't want to break printk()...
> 
> The first patch changes how two global variables are initialized,
> allowing the second patch to assume they always hold certain values.
> 
> The second patch simplifies some code based on the observation that
> the LOG_CONT and LOG_NEWLINE flags are mutually exclusive.
> 
> The third and fourth patch fix a bug in two places.  The bug is
> that a LOG_PREFIX in a record should implicitly terminate its
> predecessor, even if the predecessor was marked LOG_CONT.
> 
> The fifth patch inserts a newline in /dev/kmsg output in the
> event a LOG_PREFIX record follows a LOG_CONT record.
> 
> One trivial final patch is included at the end of the series.
> 
> 					-Alex
> 
> History:
> v2: - Added a patch to initialize two globals with LOG_NEWLINE.
>     - Changed the (now) second patch to argue that LOG_CONT and
>       LOG_NEWLINES are mutally exclusive.
>     - Added a patch to insert a newline in one case in devkmsg_read().
>     - Added some extra parentheses in some conditions, as requested.
>     - Fixed and updated some header commentary.
>     - Deleted a hunk in the typo patch, as requested.
> 
> This series, based on v3.16-rc5, is available here:
>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>     Branch review/printk-flags-v2
> 
> Alex Elder (6):
>   printk: initialize syslog_prev and console_prev
>   printk: LOG_CONT and LOG_NEWLINE are opposites
>   printk: honor LOG_PREFIX in devkmsg_read()
>   printk: honor LOG_PREFIX in msg_print_text()
>   printk: insert newline in devkmsg_read()
>   printk: correct some more typos
> 
>  kernel/printk/printk.c | 63 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 34 insertions(+), 29 deletions(-)
> 



