Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3HVV5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:57:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45852 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753084Ab3HVV5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:57:42 -0400
Message-ID: <1377208659.12003.47.camel@joe-AO722>
Subject: Re: checkpatch.pl: false warning about "-p0 patch"
From: Joe Perches <joe@perches.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 14:57:39 -0700
In-Reply-To: <20130822214553.GE14837@ld-irv-0074.broadcom.com>
References: <20130822214553.GE14837@ld-irv-0074.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 14:45 -0700, Brian Norris wrote:
> Hello,

Hello.

> I have received what appears to be a false warning from checkpatch.pl when
> checking a patch named 'b':
> 
>     $ scripts/checkpatch.pl b
>     WARNING: patch prefix 'b' exists, appears to be a -p0 patch
> 
>     total: 0 errors, 1 warnings, 16 lines checked
> 
>     b has style problems, please review.
> 
>     If any of these errors are false positives, please report
>     them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> It appears that I can trigger this warning with any arbitrary commit. The
> following bash script gives me at least one warning for everything in Linus'
> tree:
> 
>   for i in {0..100}
>   do
>       git format-patch -1 HEAD~$i --stdout > b
>       scripts/checkpatch.pl b
>   done
> 
> I have also seen this warning on patches with other names, but I'm not
> reproducing that right now.

checkpatch can use stdin as well as files/patches.

Try this instead of creating a temporary file:

for i in {0..100}
do
    git format-patch -1 --stdout HEAD~$1 | ./scripts/checkpatch.pl -
done


