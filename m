Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbbAIAqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:46:32 -0500
Received: from mga03.intel.com ([134.134.136.65]:21847 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbbAIAqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:46:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509612666"
Message-ID: <1420764374.6201.116.camel@linux.intel.com>
Subject: Re: [LKP] [xen] 054954eb051f: -49.7% kernel-size.bss
From: Huang Ying <ying.huang@linux.intel.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, LKP ML <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 08:46:14 +0800
In-Reply-To: <54AE9781.5050501@citrix.com>
References: <1420685923.6201.91.camel@linux.intel.com>
	 <54AE9781.5050501@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 14:43 +0000, David Vrabel wrote:
> On 08/01/15 02:58, Huang Ying wrote:
> > FYI, we noticed the below changes on
> > 
> > commit 054954eb051f35e74b75a566a96fe756015352c8 ("xen: switch to linear virtual mapped sparse p2m list")
> > 
> > testbox/testcase/testparams: vm-kbuild-yocto-ia32/boot/1
> > 
> > 0aad5689837c882d  054954eb051f35e74b75a566a9  
> > ----------------  --------------------------  
> >          %stddev     %change         %stddev
> >              \          |                \  
> >    4161536 ±  0%     -49.7%    2093056 ±  0%  kernel-size.bss
> 
> This is a good thing, right?

Yes.  I think so.

> >                                     kernel-size.bss
> > 
> >   4.5e+06 *+-*--*--*-*--*--*--*--*--*--*--*-*--*--*--*----------------------+
> >           |                                             *..*..              |
> >           |                                                   *..*.*..*..*..*
> >     4e+06 ++                                                                |
> >           |                                                                 |
> >           |                                                                 |
> >   3.5e+06 ++                                                                |
> >           |                                                                 |
> >     3e+06 ++                                                                |
> >           |                                                                 |
> >           |                                                                 |
> >   2.5e+06 ++                                                                |
> >           |                                                                 |
> >           O  O  O  O O  O  O  O  O  O  O  O O  O  O  O  O  O  O  O O        |
> >     2e+06 ++----------------------------------------------------------------+
> 
> I have no idea what this graph is supposed to be showing.
> 

It shows the kernel-size.bss during bisection.  From it, it can be seen
that the bisect should be good, the good value points are separated with
the bad value points clearly.

Best Regards,
Huang, Ying


