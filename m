Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaLHKlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:41:06 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60853 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaLHKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:41:04 -0500
Date: Mon, 8 Dec 2014 10:41:00 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Joe Perches <joe@perches.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: include text files in SPACE_BEFORE_TAB test
Message-ID: <20141208104100.GA6908@dm>
References: <54829801.9000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54829801.9000302@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:45:37PM -0800, Frank Rowand wrote:
> From: Frank Rowand <frank.rowand@sonymobile.com>
> 
> git-am whined about a patch that I submitted for the Documentation
> subtree, (https://lkml.org/lkml/2014/11/24/636) but checkpatch does
> not.  Make checkpatch just as whiney.
> 
> This patch moves the SPACE_BEFORE_TAB test before the check that
> excludes text files and also before the test that excludes
> assembly files.  It seems to me that both CODE_INDENT and
> SPACE_BEFORE_TAB are valid tests for assembly files, but I
> added an if around the moved CODE_INDENT test to include only
> source files, not including assembly files.  Thus this patch
> does not change which files are subject to CODE_INDENT.
> 
> The CODE_INDENT test is moved along with the SPACE_BEFORE_TAB
> test because the c76f4cb3d25e commit log says:
> 
>     This SPACE_BEFORE_TAB test is done after CODE_INDENT.
>     
>     If there are spaces used at the beginning of a line that should be
>     converted to tabs, please make sure that the CODE_INDENT test and
>     conversion is done before this SPACE_BEFORE_TAB test and conversion.
> 
> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
> ---
> 
> 
> Andy, Joe,
> 
> Assembly files are still excluded from the CODE_INDENT test -- do you
> want to make another change to include them?

The format of assembly files is rather variable.  Tabs are not used in the
same way as in the rest of the kernel.  It is not clear you can guarentee
that the rules are appropriate there.  They are also vary rarely edited
in the greater scheme of things.

-apw
