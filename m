Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIJUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:41:27 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:6437 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaIJUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:41:26 -0400
Message-ID: <1410381050.28990.295.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
From: Toshi Kani <toshi.kani@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 10 Sep 2014 14:30:51 -0600
In-Reply-To: <5410B10A.4030207@zytor.com>
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>
		 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>
		 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com>
	 <1410377428.28990.260.camel@misato.fc.hp.com> <5410B10A.4030207@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 13:14 -0700, H. Peter Anvin wrote:
> On 09/10/2014 12:30 PM, Toshi Kani wrote:
> > 
> > When WT is unavailable due to the PAT errata, it does not fail but gets
> > redirected to UC-.  Similarly, when PAT is disabled, WT gets redirected
> > to UC- as well.
> > 
> 
> But on pre-PAT hardware you can still do WT.

Yes, if we manipulates the bits directly, but such code is no longer
allowed for PAT systems.  The PAT-based kernel interfaces won't work for
pre-PAT systems, and therefore requests are redirected to UC- on such
systems. 

Thanks,
-Toshi

