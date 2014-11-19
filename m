Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaKSILE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:11:04 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40962 "HELO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932161AbaKSILC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:11:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAOftzPgYBBFTfNZunf4oGSmECzjOKF0=dnQ9EkTDFsDi+9jfNw@mail.gmail.com>
References: <1416336857-61405-1-git-send-email-joestringer@nicira.com>
	<CALnjE+qrkw92tZ-wgpGOPtbuMJVVCfo--7w6PAGO6OW4skiGQQ@mail.gmail.com>
	<CAOftzPgYBBFTfNZunf4oGSmECzjOKF0=dnQ9EkTDFsDi+9jfNw@mail.gmail.com>
Date: Wed, 19 Nov 2014 00:11:01 -0800
Message-ID: <CALnjE+rr2tFdvD+X=BbAza_5ad4DYs6viwvZWHCebQYmpvKU3Q@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net] openvswitch: Fix mask generation for IPv6 labels.
From: Pravin Shelar <pshelar@nicira.com>
To: Joe Stringer <joestringer@nicira.com>
Cc: "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:25 PM, Joe Stringer <joestringer@nicira.com> wrote:
> On 18 November 2014 22:09, Pravin Shelar <pshelar@nicira.com> wrote:
>>
>> On Tue, Nov 18, 2014 at 10:54 AM, Joe Stringer <joestringer@nicira.com>
>> wrote:
>> > When userspace doesn't provide a mask, OVS datapath generates a fully
>> > unwildcarded mask for the flow. This is done by taking a copy of the
>> > flow key, then iterating across its attributes, setting all values to
>> > 0xff. This works for most attributes, as the length of the netlink
>> > attribute typically matches the length of the value. However, IPv6
>> > labels only use the lower 20 bits of the field. This patch makes a
>> > special case to handle this.
>> >
>> > This fixes the following error seen when installing IPv6 flows without a
>> > mask:
>> >
>> > openvswitch: netlink: Invalid IPv6 flow label value (value=ffffffff,
>> > max=fffff)
>> >
>> We should allow exact match mask here rather than generating
>> wildcarded mask. So that ovs can catch invalid ipv6.label.
>
>
> I don't quite follow, I thought this was exact-match? (The existing function
> sets all bits to 1)
>
With 0xffffffff value we can exact match on all ipv6.lable bits.

> In this case, userspace has not specified a mask, but the kernel complains
> about a mask that is too wide (because it generated a mask that's too wide).
> Do you have an alternative fix in mind?

We can avoid the sanity check ipv6.lable for mask key.
