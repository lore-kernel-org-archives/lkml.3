Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaCGRie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:38:34 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:38651 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751975AbaCGRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <5319BBAE.7030109@citrix.com>
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
	<5318ABC0.4040307@citrix.com>
	<CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
	<5319BBAE.7030109@citrix.com>
Date: Fri, 7 Mar 2014 09:38:31 -0800
Message-ID: <CALnjE+pkTyHycgH+xZ+Uv=SXmoWmeUJBYa6uqWjy0L_3xG3FZg@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace via
 Netlink to avoid guest stall
From: Pravin Shelar <pshelar@nicira.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Jesse Gross <jesse@nicira.com>, Thomas Graf <tgraf@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 4:29 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> On 07/03/14 04:46, Pravin Shelar wrote:
>>
>> On Thu, Mar 6, 2014 at 9:09 AM, Zoltan Kiss <zoltan.kiss@citrix.com>
>> wrote:
>>>
>>> Do you have any feedback on this? I'm also adding KVM list as they might
>>> be
>>> interested in this.
>>>
>>> Zoli
>>>
>>>
>>> On 28/02/14 19:16, Zoltan Kiss wrote:
>>>>
>>>>
>>>> The kernel datapath now switched to zerocopy Netlink messages, but that
>>>> also
>>>> means that the pages on frags array are sent straight to userspace. If
>>>> those
>>>> pages came outside the kernel, we have to swap them out with local
>>>> copies.
>>>>
>>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>>
>>
>> I do not think this is required, netlink zero copy only maps
>> pre-allocated buffers to user-space.
>
> How do you mean "pre-allocated"? By who?
>
by netlink, ref. netlink_alloc_skb().

> As far as I've seen the skb in this function came straight from the device
> (vif in our case), and skb_zerocopy just copy the frags to user_skb, which
> is sent to the userspace. Those frags contain pages from guest, and it's a
> bad idea to pass them to userspace: e.g if userspace dies in the meantime,
> what happens with them? Also, in Xen's case they are actually not mapped to
> userspace, so accessing them can lead to garbage.
>
AFAIK Netlink does not handle skb-frags for zero-copy case.
