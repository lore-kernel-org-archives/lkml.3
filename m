Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaJXJCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:02:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50847 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaJXJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:02:42 -0400
Date: Fri, 24 Oct 2014 10:02:52 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jani Nikula <jani.nikula@intel.com>, Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: fix use via symlink, make missing spelling
 file non-fatal
Message-ID: <20141024090252.GC2910@bark>
References: <874muwv0ym.fsf@intel.com>
 <1413980418.18654.8.camel@perches.com>
 <87ppdktewn.fsf@intel.com>
 <1414085351.15751.10.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414085351.15751.10.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:29:11AM -0700, Joe Perches wrote:

[...]
>  my $P = $0;
> -$P =~ s@(.*)/@@g;
> -my $D = $1;
> +my $D = dirname(abs_path($P));

That changes the value of $P, I don't know if that is intended:

  my $D = dirname(abs_path($0));

or

  my $D = abs_path($1);

perhaps to keep $P as it was.

-apw
