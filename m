Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3BER7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:59:50 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:63826 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3BER7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:59:48 -0500
Message-ID: <1360087184.2857.2.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: No sysfs directory for openvswitch module when built-in
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Cong Wang <xiyou.wangcong@gmail.com>, Jesse Gross <jesse@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Date: Tue, 5 Feb 2013 17:59:44 +0000
In-Reply-To: <87boc0liug.fsf@rustcorp.com.au>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com>
	 <87boc0liug.fsf@rustcorp.com.au>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19612.005
X-TM-AS-Result: No--21.624200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 16:29 +1030, Rusty Russell wrote:
> Cong Wang <xiyou.wangcong@gmail.com> writes:
> > Hello, Rusty, Jesse,
> >
> > I met an interesting problem when I compile openvswitch module as a
> > built-in (actually I compile ALL kernel modules as built-in), there is
> > no /sys/module/openvswitch/ directory created by the kernel in this
> > case.
> ...
> > What's worse, the user-space init script thinks openvswitch module is
> > not loaded by checking the exist of this directory, therefore refuses
> > to start.
> 
> We only know built-in "modules" exist if we see a parameter or version
> which mention them.  Looking for /sys/module/openvswitch/ is almost as
> flawed as looking in /proc/modules.
> 
> I hacked up something which lists KBUILD_MODNAME for every element in my
> kernel which did EXPORT_KERNEL or module_init, and most of them can
> never be modules, though any could have parameters.  Even if we changed
> the build system so we could tell things which "could have been a
> module", it's silly.
[...]

Isn't this information already provided by modules.builtin?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

