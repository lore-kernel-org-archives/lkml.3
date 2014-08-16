Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaHPPmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 11:42:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaHPPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 11:42:35 -0400
Date: Sat, 16 Aug 2014 17:42:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali Roh?r <pali.rohar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: power: swsusp: Fix script for unswapping
Message-ID: <20140816154230.GB12400@Nokia-N900>
References: <1399374116-12400-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399374116-12400-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-05-06 13:01:56, Pali Roh?r wrote:
> System can have mmaped also character devices (e.g dri devices by X) or deleted
> files. Running cat on character devices is really bad idea (system can hang) so
> run cat only on regular files. Also mmaped files can have spaces in filenames.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

> ---
>  Documentation/power/swsusp.txt |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
> index 079160e..f732a83 100644
> --- a/Documentation/power/swsusp.txt
> +++ b/Documentation/power/swsusp.txt
> @@ -220,7 +220,10 @@ Q: After resuming, system is paging heavily, leading to very bad interactivity.
>  
>  A: Try running
>  
> -cat `cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u` > /dev/null
> +cat /proc/[0-9]*/maps | grep / | sed 's:.* /:/:' | sort -u | while read file
> +do
> +  test -f "$file" && cat "$file" > /dev/null
> +done
>  
>  after resume. swapoff -a; swapon -a may also be useful.
>  
> -- 
> 1.7.9.5

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
