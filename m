Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab3ICAc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:32:28 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57436 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143Ab3ICAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:32:27 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 17:32:15 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] checkpatch: Report missing spaces around trigraphs with
 --strict
Message-ID: <20130903003215.GA1614@leaf>
References: <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <20130902195056.GB32628@leaf>
 <5224EF32.5060104@roeck-us.net>
 <1378160086.1953.129.camel@joe-AO722>
 <20130902231514.GA1163@leaf>
 <1378166065.1953.134.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378166065.1953.134.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 04:54:25PM -0700, Joe Perches wrote:
> > would you mind looking at why
> > it gives a false positive for spaces around '*' on my recent patch at
> > http://mid.gmane.org/20130901234251.GB25057@leaf ?  It appears to
> > mistake the '*' of a pointer for a multiply.
> 
> Looks like checkpatch thinks this should be a multiplication.
> 
> Try this:
> ---
>  scripts/checkpatch.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9bb056c..e421b5e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3005,7 +3005,7 @@ sub process {
>  					 $op eq '*' or $op eq '/' or
>  					 $op eq '%')
>  				{
> -					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
> +					if ($ctx =~ /Wx[^WCEB]|[^WCE]xW/) {
>  						if (ERROR("SPACING",
>  							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
>  							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
> 
> 

That patch does indeed fix the problem, thanks!

Tested-by: Josh Triplett <josh@joshtriplett.org>
