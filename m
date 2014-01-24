Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaAXXRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:17:53 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37321 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaAXXRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:17:52 -0500
Date: Fri, 24 Jan 2014 15:17:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mike Waychison <mikew@google.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware/google: drop 'select EFI' to avoid recursive
 dependency
In-Reply-To: <1390604188.32356.34.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1401241517100.12813@chino.kir.corp.google.com>
References: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org> <alpine.DEB.2.02.1401231334540.7313@chino.kir.corp.google.com> <20140123134910.144a70cc0fd4c02ba0f14de4@linux-foundation.org> <alpine.DEB.2.02.1401231444510.26509@chino.kir.corp.google.com>
 <1390521727.32356.16.camel@joe-AO722> <alpine.DEB.2.02.1401240221370.9846@chino.kir.corp.google.com> <1390604188.32356.34.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Joe Perches wrote:

> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index 9c3986f..ef05ed6 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -483,6 +483,13 @@ my %deduplicate_address_hash = ();
>  
>  my @maintainers = get_maintainers();
>  
> +if ($email_maintainer && !$interactive && !$email_git_blame &&
> +    (!@maintainers || ($email_list && @maintainers == 1))) {
> +    warn "$P: No maintainer found, trying harder, addresses may be stale...\n";
> +    $email_git_blame = 1;
> +    @maintainers = get_maintainers();
> +}
> +
>  if (@maintainers) {
>      @maintainers = merge_email(@maintainers);
>      output(@maintainers);

Works well and has good advice on how emails may be stale, thanks Joe!
