Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3HVWal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:30:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51958 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754470Ab3HVWaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:30:39 -0400
Message-ID: <1377210638.12003.52.camel@joe-AO722>
Subject: Re: checkpatch.pl: false warning about "-p0 patch"
From: Joe Perches <joe@perches.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 15:30:38 -0700
In-Reply-To: <CAN8TOE9AFSVOhP1fazHK_VWZjDtqtd-Co47pGGFVvuS99qNy4A@mail.gmail.com>
References: <20130822214553.GE14837@ld-irv-0074.broadcom.com>
	 <1377208659.12003.47.camel@joe-AO722>
	 <CAN8TOE9AFSVOhP1fazHK_VWZjDtqtd-Co47pGGFVvuS99qNy4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-22 at 15:14 -0700, Brian Norris wrote:
> I realized the problem is simply with the existence of a file
> named 'b'. That is, checkpatch will give a warning for this:
>   touch b
>   git format-patch -1 --stdout | scripts/checkpatch.pl -
>   WARNING: patch prefix 'b' exists, appears to be a -p0 patch
> Is that expected?

Yes.  Basically, don't have a file (or a directory)
named a or b in the kernel root directory.

			if (!$file && $tree && $p1_prefix ne '' &&
			    -e "$root/$p1_prefix") {
				WARN("PATCH_PREFIX",
				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
			}


