Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbaCRUqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:46:52 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53181 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbaCRUqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140315013940.GA28801@wotan.suse.de>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
	<1394680527-28970-3-git-send-email-mcgrof@do-not-panic.com>
	<CAHA+R7Pf6rM5h1uGiqrru5LkN9C7Nm7V42cucHSOV1s7_+F7Gw@mail.gmail.com>
	<20140315013940.GA28801@wotan.suse.de>
Date: Tue, 18 Mar 2014 13:46:49 -0700
Message-ID: <CAHA+R7MRVyjAN7w_qPxSxkrjo939bNEc3Ej+O3yH-oWj4gGJxw@mail.gmail.com>
Subject: Re: [PATCH 2/3] bridge: trigger a bridge calculation upon port changes
From: Cong Wang <cwang@twopensource.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 6:39 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Mar 13, 2014 at 11:26:25AM -0700, Cong Wang wrote:
>> On Wed, Mar 12, 2014 at 8:15 PM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> >                         spin_unlock_bh(&p->br->lock);
>> > +                       if (changed)
>> > +                               call_netdevice_notifiers(NETDEV_CHANGEADDR,
>> > +                                                        p->br->dev);
>> > +                       netdev_update_features(p->br->dev);
>>
>> I think this is supposed to be in netdev event handler of br->dev
>> instead of here.
>
> Do you mean netdev_update_features() ? I mimic'd what was being done on
> br_del_if() given that root blocking is doing something similar. If
> we need to change something for the above then I suppose it means we need
> to change br_del_if() too. Let me know if you see any reason for something
> else.
>

Yeah, for me it looks like it's better to call netdev_update_features()
in the event handler of br->dev, rather than where calling
call_netdevice_notifiers(..., br->dev);.
