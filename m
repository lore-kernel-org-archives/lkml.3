Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbbAPUxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:53:55 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:40256 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751581AbbAPUxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:53:54 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 15:53:54 EST
MIME-Version: 1.0
In-Reply-To: <CALnjE+o5kXhDK+uaE4ajF2MAWwgG21rhYNgpD70rWLQc9AQqHg@mail.gmail.com>
References: <1421358507-5992-1-git-send-email-joestringer@nicira.com>
 <1421358507-5992-6-git-send-email-joestringer@nicira.com> <CALnjE+o5kXhDK+uaE4ajF2MAWwgG21rhYNgpD70rWLQc9AQqHg@mail.gmail.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Fri, 16 Jan 2015 12:46:48 -0800
Message-ID: <CANr6G5wYcm_2wrhE--6=fW9mTy2hjw5VJ4SyJa+JZQPZoHN8Hg@mail.gmail.com>
Subject: Re: [PATCH net-next v12 5/5] openvswitch: Add support for unique flow IDs.
To: Pravin Shelar <pshelar@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2015 at 00:07, Pravin Shelar <pshelar@nicira.com> wrote:
>> @@ -213,13 +223,15 @@ struct flow_stats {
>>
>>  struct sw_flow {
>>         struct rcu_head rcu;
>> -       struct hlist_node hash_node[2];
>> -       u32 hash;
>> +       struct {
>> +               struct hlist_node node[2];
>> +               u32 hash;
>> +       } flow_table, ufid_table;
>>         int stats_last_writer;          /* NUMA-node id of the last writer on
>>                                          * 'stats[0]'.
>>                                          */
>>         struct sw_flow_key key;
>> -       struct sw_flow_key unmasked_key;
>> +       struct sw_flow_id *id;
>>         struct sw_flow_mask *mask;
>>         struct sw_flow_actions __rcu *sf_acts;
>>         struct flow_stats __rcu *stats[]; /* One for each NUMA node.  First one
>> @@ -243,6 +255,16 @@ struct arp_eth_header {
>>         unsigned char       ar_tip[4];          /* target IP address        */
>>  } __packed;
>>
> In last round we agreed on following struct flow-id which saves around
> four hundred bytes per flow and kmalloc per flow add operation for
> common case. Is there any reason for not doing it?
>
> struct {
>      u32 ufid_len;
>      union {
>          u32 ufid[MAX_UFID_LENGTH / 4];
>          struct sw_flow_key *unmasked_key;
>      }
> } id;

Ah, I thought I had addressed this before the holidays but it's
clearly not we had discussed. Thanks for bringing this up, I'll make
this change and repost.
