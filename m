Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaC3But (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:50:49 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64969 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaC3Bur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:50:47 -0400
Message-ID: <1396144245.29410.2.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next v2] net-sysfs: expose number of carrier on/off
 changes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Decotigny <decot@googlers.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Weilong Chen <chenweilong@huawei.com>, Jiri Pirko <jiri@resnulli.us>,
        Amir Vadai <amirv@mellanox.com>, Michael Dalton <mwdalton@google.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>
Date: Sat, 29 Mar 2014 18:50:45 -0700
In-Reply-To: <20140329183628.509f1239@nehalam.linuxnetplumber.net>
References: <cover.1396111568.git.decot@googlers.com>
	 <2fd338e34d809af14353a03bc1edd0935f332faf.1396111568.git.decot@googlers.com>
	 <20140329183628.509f1239@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-29 at 18:36 -0700, Stephen Hemminger wrote:
> On Sat, 29 Mar 2014 09:48:35 -0700
> David Decotigny <decot@googlers.com> wrote:
> 
> > This allows to monitor carrier on/off transitions and detect link
> > flapping issues:
> >  - new /sys/class/net/X/carrier_changes
> >  - new rtnetlink IFLA_CARRIER_CHANGES (getlink)
> > 
> > Tested:
> >   - grep . /sys/class/net/*/carrier_changes
> >     + ip link set dev X down/up
> >     + plug/unplug cable
> >   - updated iproute2: prints IFLA_CARRIER_CHANGES
> >   - iproute2 20121211-2 (debian): unchanged behavior
> > 
> > Signed-off-by: David Decotigny <decot@googlers.com>
> 
> Is there a related SNMP MIB variable? should there be?

I don't think we have any SNMP MIB variable for devices ?

It seems "ip link" is the facto standard.

(BTW we put BusyPollRxPackets in TcpExt group, this was an error IMHO)


