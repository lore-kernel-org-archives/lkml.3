Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaCDAxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:53:43 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46138 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaCDAxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140303163159.365d763b@nehalam.linuxnetplumber.net>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
 <1393886825-24323-5-git-send-email-mcgrof@do-not-panic.com>
 <20140303154330.238a20bc@nehalam.linuxnetplumber.net> <CAB=NE6VpjebGrqFe7Q4L-uM0rrKitY3fB2kq5qGko+C1Fivm0w@mail.gmail.com>
 <20140303163159.365d763b@nehalam.linuxnetplumber.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 3 Mar 2014 16:53:19 -0800
X-Google-Sender-Auth: YAoH8HYMg0WhzfjXNb99PJDxilM
Message-ID: <CAB=NE6W0YwRb_CoTaNNoa=OMu_BVecjh7frBPJ_Ci3AwqboCSQ@mail.gmail.com>
Subject: Re: [RFC v3 4/6] bridge: enable root block during device registration
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 4:31 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Mon, 3 Mar 2014 15:58:50 -0800
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
>
>> On Mon, Mar 3, 2014 at 3:43 PM, Stephen Hemminger
>> <stephen@networkplumber.org> wrote:
>> > Doing this in priv flags bloats what is a limited resource (# of bits).
>>
>> Agreed. I tried to avoid it but saw no other option for addressing
>> this during initialization properly without requirng a userspace
>> upgrade.
>
> Replacing one Xen hack for another doesn't seem like great progress.

I'm the last person that wants to see any internal driver hack
propagate, the goal was to kill one here.

> I would rather see an API change as needed because there are other
> things like setting STP parameters which might also want to be part
> of initial device add.

As it stands right now ndo_add_slave() currently only allows us to
pass the net_device, that's it, so we're confined there. One way I can
think of to properly extend this interface is to allow extra
parameters to be passed. We may even be able to move some old
priv_flags for bonding onto this new interface but before I moved down
this more invasive approach I wanted to review this other approach.
Does extending ndo_add_slave() seems reasonable, or do you have any
other preferred alternatives?

Even though the high MAC address was a xen hack it is a hack put in
place prior to the root block feature being added, so I would like at
the very least a bit of consideration on userspace here. Its really
the only reason why I've been stubborn on looking for a compromise. In
the KVM case that doesn't use the root_block feature yet I would have
considered just extending the ndo_add_slave() from the start but
because xen-netback *does* have in place a hack removing it requires
userspace considerations.

  Luis
