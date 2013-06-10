Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3FJLUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:20:33 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:48615 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3FJLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:20:32 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 07:20:32 EDT
Date: Mon, 10 Jun 2013 13:14:45 +0200
From: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] scripts/setlocalversion on write-protected source tree
Message-ID: <20130610111445.GA17553@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
	Christian Kujau <lists@nerdbynature.de>,
	LKML <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.10.1306091640270.13746@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1306091640270.13746@trent.utfs.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: bento (Linux 3.9.3-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Christian,

Christian Kujau [Sun, Jun 09, 2013 at 05:50:49PM -0700]:
> Hi,
> 
> [errors when using git update-index - different scenarios]
> [...]
> 
> On a side note, I don't think a kernel compilation should alter the source 
> tree (or the .git directory) in any way and I don't see how removing 
> "git update-index" could do any harm. The Mercurial and SVN routines in 
> scripts/setlocalversion don't have any tree-modifying commands, AFAICS. 
> So, maybe the attached patch would be acceptable.
> 
> [...]

As --refresh is being used, I guess (!) the motivation was to update the
index for stat changes that may have taken place elsewhere (like on
NFS) - not sure whether this actually matches (can somebody confirm /
overturn this theory?).

I do however agree with you that setlocalversion should probably not
try to fix this problem, but leave it to the user to update the index,
if necessary.

So I'd personally go for your second patch.

Cheers,

Nico

> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index 84b88f1..d105a44 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -71,9 +71,6 @@ scm_version()
>  			printf -- '-svn%s' "`git svn find-rev $head`"
>  		fi
>  
> -		# Update index only on r/w media
> -		[ -w . ] && git update-index --refresh --unmerged > /dev/null
> -
>  		# Check for uncommitted changes
>  		if git diff-index --name-only HEAD | grep -qv "^scripts/package"; then
>  			printf '%s' -dirty


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
