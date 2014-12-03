Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaLCVnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:43:03 -0500
Received: from na6sys009bog005.obsmtp.com ([74.125.150.50]:45753 "HELO
	na6sys009bog005.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751639AbaLCVm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:42:59 -0500
MIME-Version: 1.0
In-Reply-To: <CALnjE+pNbwtGPsHfTJ0FXxdSpXT=AKgtfHPqT5matCx+PGcXbA@mail.gmail.com>
References: <1417575363-13770-1-git-send-email-joestringer@nicira.com> <CALnjE+pNbwtGPsHfTJ0FXxdSpXT=AKgtfHPqT5matCx+PGcXbA@mail.gmail.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 3 Dec 2014 13:42:38 -0800
Message-ID: <CANr6G5xWMYv2=z7TES+pYqHDqxFmrzP+RpXfUDC6qUL_yqkJEQ@mail.gmail.com>
Subject: Re: [PATCHv11 net-next 1/2] openvswitch: Refactor ovs_nla_fill_match().
To: Pravin Shelar <pshelar@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2014 at 11:37, Pravin Shelar <pshelar@nicira.com> wrote:
> On Tue, Dec 2, 2014 at 6:56 PM, Joe Stringer <joestringer@nicira.com> wrote:
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 332b5a0..b2a3796 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -462,10 +462,8 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>>                              0, upcall_info->cmd);
>>         upcall->dp_ifindex = dp_ifindex;
>>
>> -       nla = nla_nest_start(user_skb, OVS_PACKET_ATTR_KEY);
>> -       err = ovs_nla_put_flow(key, key, user_skb);
>> +       err = ovs_nla_put_flow(key, key, OVS_PACKET_ATTR_KEY, false, user_skb);
>
> We need different name here, since it does not operate on flow. maybe
> __ovs_nla_put_key(). we can move the function definition to
> flow_netlink.h

OK sure. I'll fix this up for the next version.
