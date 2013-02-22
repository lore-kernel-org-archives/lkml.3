Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3BVWBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:01:55 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:59844 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3BVWBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:01:54 -0500
Message-ID: <1361570508.5608.10.camel@thor.lan>
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
From: Peter Hurley <peter@hurleysoftware.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 17:01:48 -0500
In-Reply-To: <1361566784.2030.6.camel@joe-AO722>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	 <1361566784.2030.6.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 12:59 -0800, Joe Perches wrote:
> Add the ClearPage/SetPage/TestClearPage/TestSetPage
> variants to the not reported Page CamelCase variables.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 747bcd7..8a32306 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2930,7 +2930,7 @@ sub process {
>  			my $var = $1;
>  			if ($var !~ /$Constant/ &&
>  			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> -			    $var !~ /^Page[A-Z]/ &&
> +			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
>  			    !defined $camelcase{$var}) {
>  				$camelcase{$var} = 1;
>  				WARN("CAMELCASE",
> 

In a recent patch, checkpatch gave this warning.

WARNING: Avoid CamelCase: <tty->SAK_work>
#35: FILE: drivers/tty/tty_io.c:1475:
+	flush_work(&tty->SAK_work);


'SAK' is the acronym for 'Secure Attention Key'. Identifiers which
relate to SAK handling have the above form; eg.,
  do_SAK()
  SAK_work
  do_SAK_work
  fn_SAK
  vc_SAK
  sysrq_handle_SAK

I didn't bother to mention it before, but since your addressing mm
CamelCase exceptions, perhaps

  xxxx_XXXX
  xx_XXX_xxx
  XXX_xxx

could be exceptions as well?

Regards,
Peter Hurley

