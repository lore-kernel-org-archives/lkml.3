Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaGZPG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:06:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55568 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaGZPG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:06:27 -0400
Message-ID: <1406387114.4985.6.camel@popy-debian>
Subject: Re: [PATCH 1/1] neighbour : fix ndm_type type error issue
From: Jun Zhao <mypopydev@gmail.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Cong Wang <cwang@twopensource.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen hemminger <stephen@networkplumber.org>,
        Tom Herbert <therbert@google.com>, netdev@vger.kernel.org,
        Francesco Fusco <ffusco@redhat.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Stevens <dlstevens@us.ibm.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Daniel Borkmann <dborkman@redhat.com>, linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2014 23:05:14 +0800
In-Reply-To: <1406382166.19420.145911853.784D75D0@webmail.messagingengine.com>
References: <1406306339-16151-1-git-send-email-mypopydev@gmail.com>
	 <1406330697.989.145785925.1CA960AF@webmail.messagingengine.com>
	 <1406334557.5276.13.camel@popy-debian>
	 <1406382166.19420.145911853.784D75D0@webmail.messagingengine.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hannes

On Sat, 2014-07-26 at 15:42 +0200, Hannes Frederic Sowa wrote:
> Hi,
> 
> On Sat, Jul 26, 2014, at 02:29, Jun Zhao wrote:
> > On Sat, 2014-07-26 at 01:24 +0200, Hannes Frederic Sowa wrote:
> > > On Fri, Jul 25, 2014, at 18:38, Jun Zhao wrote:
> > > > ndm_type means L3 address type, in neighbour proxy and vxlan, it's
> > > > RTN_UNICAST.
> > > > NDA_DST is for netlink TLV type, hence it's not right value in this
> > > > context.
> > > 
> > > The value of NDA_DST == RTN_UNICAST, otherwise we couldn't do this
> > > change as it would alter e.g. arpd behavior.
> > > 
> > > Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > > 
> > > Thanks,
> > > Hannes
> > 
> > But I think NDA_DST/RTN_UNICAST have different means in this context, 
> > even though the value of NDA_DST == RTN_UNICAST.
> > 
> > For arp proxy/NDP proxy context, ndm_type means the peer L3 address,
> > so RTN_UNICAST is the right value. For vxlan have similar semantic for
> > remote ip.
> > 
> > BTW: In the source code, implicit think NDA_DST == RTN_UNICAST maybe
> > not a good idea when we don't have a comment or the other explain.
> 
> I am totally with you and think your change is good, that's why I also
> gave my ack to your patch.
> 
> My comment above was about my concerns regarding making a user space
> visible change, which in the end could alter the behavior of already
> existing software.
> 
> Developers maybe have debugged code and seen some different value being
> propagated from the kernel and this software could now break if we would
> change the value after all those years.
> 
> Bye,
> Hannes

Lucky， NDA_DST == RTN_UNICAST is true really in source code ：）

/* rtm_type */

enum {
	RTN_UNSPEC,
	RTN_UNICAST,		
...
}

enum {
	NDA_UNSPEC,
	NDA_DST,
...
}


