Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaJOTm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:42:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJOTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:42:26 -0400
Date: Wed, 15 Oct 2014 12:42:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] checkpatch: Add error on use of attribute((weak))
 or __weak
Message-Id: <20141015124225.01a4cad19c4f3a198efc996e@linux-foundation.org>
In-Reply-To: <4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
References: <cover.1413400022.git.joe@perches.com>
	<4391d882bb26278110d07b9a5e23ec44f5f8328a.1413400022.git.joe@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 12:32:08 -0700 Joe Perches <joe@perches.com> wrote:

> Using weak can have unintended link defects.
> Emit an error on its use.

Well, we don't want a warning about use of __weak in function
definitions.  Only in declarations.

> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4671,6 +4671,14 @@ sub process {
>  			}
>  		}
>  
> +# Check for __attribute__ weak, or __weak (may have link issues)
> +		if ($realfile !~ m@\binclude/uapi/@ &&

And this bit maybe is checking for use in a header file, which is not
as good as checking for a declaration but is probably good enough. 
However the "uapi" bit is confusing.

Can we have a better changelog please?

> +		    ($line =~ /\b__attribute__\s*\(\s*\(.*\bweak\b/ ||
> +		     $line =~ \b__weak\b/)) {
> +			ERROR("AVOID_WEAK",
> +			      "Using weak can have unintended link defects" . $herecurr);
> +		}
> +
>  # check for sizeof(&)
>  		if ($line =~ /\bsizeof\s*\(\s*\&/) {
>  			WARN("SIZEOF_ADDRESS",
> -- 
> 2.1.0
