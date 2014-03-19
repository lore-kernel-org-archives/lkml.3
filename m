Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690AbaCSQJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:09:20 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42576 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965484AbaCSQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:09:16 -0400
Message-ID: <1395245350.1741.6.camel@localhost.localdomain>
Subject: Re: [Bridge] [PATCH 1/3] bridge: preserve random init MAC address
From: Toshiaki Makita <toshiaki.makita1@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>, kvm@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        xen-devel@lists.xenproject.org
Date: Thu, 20 Mar 2014 01:09:10 +0900
In-Reply-To: <CAB=NE6VL8LCGa5aqm8qpgwHywwvVb8gjNQFKic_Dq9zdg-8hDQ@mail.gmail.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
	 <1394680527-28970-2-git-send-email-mcgrof@do-not-panic.com>
	 <5328E802.3030901@lab.ntt.co.jp>
	 <CAB=NE6X2eZFLWBN1acf=d75T_K2YM_OK3oaXEPu-hwpUJEmwkg@mail.gmail.com>
	 <5328ED25.1040900@lab.ntt.co.jp>
	 <CAB=NE6VL8LCGa5aqm8qpgwHywwvVb8gjNQFKic_Dq9zdg-8hDQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 18:10 -0700, Luis R. Rodriguez wrote:
> On Tue, Mar 18, 2014 at 6:04 PM, Toshiaki Makita
> <makita.toshiaki@lab.ntt.co.jp> wrote:
> > (2014/03/19 9:50), Luis R. Rodriguez wrote:
> >> On Tue, Mar 18, 2014 at 5:42 PM, Toshiaki Makita
> >> <makita.toshiaki@lab.ntt.co.jp> wrote:
> >>> nit,
> >>> If the last detached port happens to have the same addr as
> >>> random_init_addr, this seems to call br_stp_change_bridge_id() even
> >>> though bridge_id is not changed.
> >>
> >> Ah good point.
> >>
> >>> Shouldn't the assignment of random_init_addr be done before the check of
> >>> "no change"?
> >>
> >> Good question, should we even allow two ports to have the same MAC
> >> address or should we complain and refuse to add it? If so that should
> >> mean we should also have to monitor any manual address changes or
> >> events for address changes on the ports.
> >
> > This was recently discussed by Stephen and me.
> > I'm thinking it should be allowed.
> >
> > http://marc.info/?l=linux-netdev&m=139182743919257&w=2
> 
> Great now that that's sorted out though I still think calling
> br_stp_change_bridge_id() is right just as calling the update features
> as the device is different. It could however be confusing when this
> situation is run and folks might report odd bugs unless we could tell
> them apart clearly. Thoughts?

br_stp_change_bridge_id() is currently called only if bridge_id.addr
should be changed.
If the addr should not be changed but some updates are needed,
br_stp_recalculate_bridge_id() doesn't seem to fit into it.

Toshiaki Makita

