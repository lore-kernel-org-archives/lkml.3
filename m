Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab3BVWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:39:00 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:33847 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3BVWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:38:58 -0500
Message-ID: <1361572731.9721.1.camel@thor.lan>
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
From: Peter Hurley <peter@hurleysoftware.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 17:38:51 -0500
In-Reply-To: <1361571667.2030.13.camel@joe-AO722>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	 <1361566784.2030.6.camel@joe-AO722> <1361570508.5608.10.camel@thor.lan>
	 <1361571667.2030.13.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:21 -0800, Joe Perches wrote:
> On Fri, 2013-02-22 at 17:01 -0500, Peter Hurley wrote:
> > I didn't bother to mention it before, but since your addressing mm
> > CamelCase exceptions, perhaps
> > 
> >   xxxx_XXXX
> >   xx_XXX_xxx
> >   XXX_xxx
> > 
> > could be exceptions as well?
> 
> Maybe the check should only be for "[A-Z][a-z]|[a-z][A-Z]"
> to make '_' and any non-alpha char a name barrier.
> 
> So vars like A_foo or b_9A would be acceptable.
> 
> Maybe:
> 
> ---
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 747bcd7..e08e9f6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2929,8 +2929,8 @@ sub process {
>  		while ($line =~ m{($Constant|$Lval)}g) {
>  			my $var = $1;
>  			if ($var !~ /$Constant/ &&
> -			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> -			    $var !~ /^Page[A-Z]/ &&
> +			    $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
> +			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ && &&
                                                                                    ^^^^^
                                                                                    &&  

>  			    !defined $camelcase{$var}) {
>  				$camelcase{$var} = 1;
>  				WARN("CAMELCASE",

Other than that, works for me :)


