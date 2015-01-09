Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbbAIRoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:44:19 -0500
Received: from smtp102.biz.mail.bf1.yahoo.com ([98.139.221.61]:37263 "EHLO
	smtp102.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbbAIRoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:44:15 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nSfELNYVM1nH8lAeg33DSRwPxptn9TlF44fmr39QTCYF.S9
 nmGguMa3NqYjq0rrDlD3pMVTEts9FGqSFxDJMbVcfdZpjS.Bk5_oWwSvRcIW
 RdrNrnzEGAa50ao734PJwlRriqf8mdgBfygqtycEMAVdEvKKmPIHUMy1j4jN
 esJGzOAEp0DyuRID.s7HlHFeaPPc.ioxnmerquzTrXr.W2jiileqpZ9Puk09
 gGIj3xKxMvmah9_DYAKYemU7uf0XNUDObK5X55mDO5iSjy460JahJzDJOqBQ
 OmxtYYX41XkgZwdq2XCyGWew329h0MhO9w7qcW4NfO2DQzOBQo9ObWwDu2Ha
 CZeeExy06DqW1lgcD70NDZSua7uVZyqoLUA3Z.2Ah7guVCnLbMeeYy2.Pb3G
 hpdAZm6VlKaYJAu5YC9loA.J95JnU9H4nW1cvHL36Y70nVLdLAXoIo_N8ISk
 uSvoO.ORh2JSqckOQ5VOPrYDvl3rdO.Irq3gOVZSJF_YJngTlAInN9StmmYp
 GEc_ImKzs9Za45oZcIu.ocxC45j2pxc7HgsBhNDtpZTyeMrhpGRATF6UmAvL
 GwRraXfWJUz7rWkW8qDsHgHnuhB.WxUu_JCtn7_S0N7TiDye3tb_o2FPI9ZX
 sMzidl7GU0l1WBeURoFCuD3CQsbXZ5gNqijYcGMvKEkZ1BG8OUrgBKF5bxH7
 wWZVSObZhsBIGB_i1UiNgO0yzIUk-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <54B0136C.6090205@schaufler-ca.com>
Date: Fri, 09 Jan 2015 09:44:12 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Vishal Goel <goel.cool@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Fix for synchronization issue in IPV6 implementation in smack
 module(v3.18)
References: <CABP0=5eXSCW=yp8iqyXNzXMsYNM7L0T0TFefrOZsj2wpbakfXQ@mail.gmail.com> <20150109134231.GA18921@vivalin-002>
In-Reply-To: <20150109134231.GA18921@vivalin-002>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2015 5:42 AM, Ahmed S. Darwish wrote:
> Hi Vishal,
>
> On Thu, Jan 08, 2015 at 10:11:52PM +0530, Vishal Goel wrote:
>>  [PATCH] This patch fixes the synchronization issue in IPv6
>>  implementation. Previously there was no synchronization mechanism used while
>>  accessing(adding/reading/deletion) smk_ipv6_port_list. It could be possible
>>  that when one thread is reading the list, at the same time another thread is
>>  adding/deleting in the list.So it is possible that reader thread will read
>>  the inaccurate or incomplete list. So to make sure that reader thread will
>>  read the accurate list, rcu mechanism has been used while accessing the
>>  list.RCU allows readers to access a data structure even when it is in the
>>  process of being updated
>>
>> Signed-off-by: Vishal Goel <vishal.goel@samsung.com>
>>             Himanshu Shukla <himanshu.sh@samsung.com>
> The legality of your patches are blurry. You're sending from
> a personal email, while having Signed-off-by signatures by your
> employer.
>
> You **really** need to add a "From: XXX@samsung.com" header on
> the very first line of your emails if this is a sponsored work.
> Kindly check Documentation/SubmittingPatches for further details.
>
> Beside the above:
>
> - Your patches are not applicable to the tree since they're
>   white-spaces mangled. You're using Gmail's web interface, which
>   is well known at converting tabs to white-spaces. Check
>   Documentation/email-clients.txt for further details.
>
> - Please fix you Subject line. Make it something in the form of:
>   [PATCH 1/3] smack: Fix xxx
>
> - No need for "[PATCH]" in the commit log body, only in the
>   subject line.
>
> - Please make the commit message more comprehensible. Check
>   the kernel git log history for good examples. A grammar
>   check will also be nice; there are a number of free good
>   tools on the web.
>
> - Add "Signed-off-by" headers for each developer. In the patch
>   above, you'll need _two_ "Signed-off-by" lines.
>
> - You're sending multiple related patches, but posting each one
>   in its own thread. This will make it very very hard for review,
>   especially in a very busy list like LKML. Please send related
>   patches in an "email thread", with clear sequence numbers.
>
>   (e.g., your follow-up patch titled as "In Ref to previous 3
>   patches:Fix for synchronization..." is completely bogus.)
>
> Happy kernel coding :-)
>
> Regards,
> Darwish

Further, they still are based on the wrong tree.
These patches need to be based on the smack-next tree:

	git://git.gitorious.org/smack-next/kernel.git
	branch smack-for-3.20

There has been other work on the IPv6 code for 3.20.
Your patches, even when demangled, do not apply.


>
>> ---
>>  security/smack/smack_lsm.c | 21 +++++++++++++++------
>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index d515ec2..b3427ee 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -52,6 +52,7 @@
>>  #define SMK_RECEIVING  1
>>  #define SMK_SENDING    2
>>
>> +DEFINE_MUTEX(smack_ipv6_lock);
>>  LIST_HEAD(smk_ipv6_port_list);
>>
>>  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
>> @@ -2232,17 +2233,20 @@ static void smk_ipv6_port_label(struct socket
>> *sock, struct sockaddr *address)
>>              * on the bound socket. Take the changes to the port
>>              * as well.
>>              */
>> -           list_for_each_entry(spp, &smk_ipv6_port_list, list) {
>> +           rcu_read_lock();
>> +           list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>>                   if (sk != spp->smk_sock)
>>                         continue;
>>                   spp->smk_in = ssp->smk_in;
>>                   spp->smk_out = ssp->smk_out;
>> +                 rcu_read_unlock();
>>                   return;
>>             }
>>             /*
>>              * A NULL address is only used for updating existing
>>              * bound entries. If there isn't one, it's OK.
>>              */
>> +           rcu_read_unlock();
>>             return;
>>       }
>>
>> @@ -2258,16 +2262,18 @@ static void smk_ipv6_port_label(struct socket
>> *sock, struct sockaddr *address)
>>        * Look for an existing port list entry.
>>        * This is an indication that a port is getting reused.
>>        */
>> -     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>>             if (spp->smk_port != port)
>>                   continue;
>>             spp->smk_port = port;
>>             spp->smk_sock = sk;
>>             spp->smk_in = ssp->smk_in;
>>             spp->smk_out = ssp->smk_out;
>> +           rcu_read_unlock();
>>             return;
>>       }
>> -
>> +     rcu_read_unlock();
>>       /*
>>        * A new port entry is required.
>>        */
>> @@ -2280,7 +2286,9 @@ static void smk_ipv6_port_label(struct socket
>> *sock, struct sockaddr *address)
>>       spp->smk_in = ssp->smk_in;
>>       spp->smk_out = ssp->smk_out;
>>
>> -     list_add(&spp->list, &smk_ipv6_port_list);
>> +     mutex_lock(&smack_ipv6_lock);
>> +     list_add_rcu(&spp->list, &smk_ipv6_port_list);
>> +     mutex_unlock(&smack_ipv6_lock);
>>       return;
>>  }
>>
>> @@ -2335,8 +2343,8 @@ static int smk_ipv6_port_check(struct sock *sk,
>> struct sockaddr_in6 *address,
>>             skp = &smack_known_web;
>>             goto auditout;
>>       }
>> -
>> -     list_for_each_entry(spp, &smk_ipv6_port_list, list) {
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(spp, &smk_ipv6_port_list, list) {
>>             if (spp->smk_port != port)
>>                   continue;
>>             object = spp->smk_in;
>> @@ -2344,6 +2352,7 @@ static int smk_ipv6_port_check(struct sock *sk,
>> struct sockaddr_in6 *address,
>>                   ssp->smk_packet = spp->smk_out;
>>             break;
>>       }
>> +     rcu_read_unlock();
>>
>>  auditout:
>>
>> --
>> 1.8.3.2
>> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

