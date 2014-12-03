Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLCSru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:47:50 -0500
Received: from na6sys009bog035.obsmtp.com ([74.125.150.109]:56937 "HELO
	na6sys009bog035.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751041AbaLCSrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <1417575363-13770-2-git-send-email-joestringer@nicira.com>
References: <1417575363-13770-1-git-send-email-joestringer@nicira.com> <1417575363-13770-2-git-send-email-joestringer@nicira.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 3 Dec 2014 10:47:26 -0800
Message-ID: <CANr6G5z-kokWkBs3bb=bXrBmBUhaqHKH1QfeXycFWxSNf00qFw@mail.gmail.com>
Subject: Re: [PATCHv11 net-next 2/2] openvswitch: Add support for unique flow IDs.
To: Pravin Shelar <pshelar@nicira.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention that this is the first post based against net-next.

On 2 December 2014 at 18:56, Joe Stringer <joestringer@nicira.com> wrote:
> <....snip...>
> diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
> index a8b30f3..7f31dbf 100644
> --- a/net/openvswitch/flow.h
> +++ b/net/openvswitch/flow.h
> @@ -197,6 +197,13 @@ struct sw_flow_match {
>         struct sw_flow_mask *mask;
>  };
>
> +#define MAX_UFID_LENGTH 256
> +
> +struct sw_flow_id {
> +       u32 ufid_len;
> +       u32 ufid[MAX_UFID_LENGTH / 4];
> +};
> +
>  struct sw_flow_actions {
>         struct rcu_head rcu;
>         u32 actions_len;

Pravin, I changed the 'struct sw_flow_id' to the above after feedback
from the previous round, but it doesn't seem quite right. Is this what
you meant? Given that current ovs-vswitchd userspace only generates
128bit UFIDs, it seems wasteful to be allocating so much for this. Did
you have in mind for this to be united with the unmasked_key?
