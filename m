Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbaDVSDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:03:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50707 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335AbaDVSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:03:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,905,1389744000"; 
   d="scan'208";a="122380305"
Message-ID: <5356AEBF.5010505@citrix.com>
Date: Tue, 22 Apr 2014 19:02:39 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
CC: David Miller <davem@davemloft.net>, <jesse@nicira.com>,
        <pshelar@nicira.com>, <tgraf@redhat.com>, <dev@openvswitch.org>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>,
        <edumazet@google.com>, <dborkman@redhat.com>, <therbert@google.com>,
        <jasowang@redhat.com>, <fw@strlen.de>, <joe@perches.com>,
        <horms@verge.net.au>, <jiri@resnulli.us>, <mst@redhat.com>,
        <Paul.Durrant@citrix.com>, <JBeulich@suse.com>,
        <herbert@gondor.apana.org.au>, <mszeredi@suse.cz>,
        <netfilter-devel@vger.kernel.org>, <netfilter@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5] core, nfqueue, openvswitch: Orphan frags in skb_zerocopy
 and handle errors
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>	 <20140327.152956.1528740039185894234.davem@davemloft.net>	 <20140421112601.GC3200@hercules> <1398181118.3624.203.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1398181118.3624.203.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/14 16:38, Ben Hutchings wrote:
> On Mon, 2014-04-21 at 12:26 +0100, Luis Henriques wrote:
>> Hi David,
>>
>> On Thu, Mar 27, 2014 at 03:29:56PM -0400, David Miller wrote:
>>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>>> Date: Wed, 26 Mar 2014 22:37:45 +0000
>>>
>>>> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
>>>> orphan them. Also, it doesn't handle errors, so this patch takes care of that
>>>> as well, and modify the callers accordingly. skb_tx_error() is also added to
>>>> the callers so they will signal the failed delivery towards the creator of the
>>>> skb.
>>>>
>>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>>>
>>> Fingers crossed :-)  Applied, thanks Zoltan.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> Could you please queue this for stable as well?  It has CVE-2014-2568
>> assigned to it and I believe it is applicable to some of the trees.
>
> It was applied to 3.13, but needs backporting to earlier versions.  I
> posted my attempt in
> <1397429860.10849.86.camel@deadeye.wl.decadent.org.uk> but it needs
> testing/reviewing.

This one is a different issue, although it is very similar.

Zoli

