Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3BVSho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:37:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab3BVShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:37:43 -0500
Message-ID: <5127BAD2.1040007@oracle.com>
Date: Fri, 22 Feb 2013 13:37:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Antonio Quartulli <ordex@autistici.org>
CC: Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: batman-adv: gpf in batadv_slide_own_bcast_window
References: <5127A2AF.9030502@oracle.com> <20130222170621.GU3523@ritirata.org>
In-Reply-To: <20130222170621.GU3523@ritirata.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 12:06 PM, Antonio Quartulli wrote:
> Hi Sasha and thank you very much for reporting this issue.
> 
> IIRC this is similar to a bug you already reported in the past.
> This bug should be the result of a race condition batman-adv has in the
> hard-interface handling code (this is why it has been triggered while removing
> eth0).
> 
> Now that the rtnl-deadlock has been solved I think we can try to further
> investigate on this bug and try to find a solution..though it will not be easy
> as it probably requires another lock to protect the hard-interface during this
> operations.
> 
> If you have any fix proposal feel free to contribute!

I'm confused about how batadv_orig_hash_del_if removes an interface from the
hashtable. I see the hashtable is using rcu to protect it, but when we
delete an entry we free it straight away by calling batadv_orig_node_del_if()
and not going through kfree_rcu().

Is there a reason behind doing that, or might it be the cause of the problem
we're seeing here?


Thanks,
Sasha
