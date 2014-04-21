Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaDUL0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:26:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDUL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:26:28 -0400
Date: Mon, 21 Apr 2014 12:26:01 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: zoltan.kiss@citrix.com, jesse@nicira.com, pshelar@nicira.com,
        tgraf@redhat.com, dev@openvswitch.org, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, edumazet@google.com, dborkman@redhat.com,
        therbert@google.com, jasowang@redhat.com, fw@strlen.de,
        joe@perches.com, horms@verge.net.au, jiri@resnulli.us, mst@redhat.com,
        Paul.Durrant@citrix.com, JBeulich@suse.com,
        herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
Message-ID: <20140421112601.GC3200@hercules>
References: <1395873465-22282-1-git-send-email-zoltan.kiss@citrix.com>
 <20140327.152956.1528740039185894234.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140327.152956.1528740039185894234.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Mar 27, 2014 at 03:29:56PM -0400, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Wed, 26 Mar 2014 22:37:45 +0000
> 
> > skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
> > orphan them. Also, it doesn't handle errors, so this patch takes care of that
> > as well, and modify the callers accordingly. skb_tx_error() is also added to
> > the callers so they will signal the failed delivery towards the creator of the
> > skb.
> > 
> > Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> 
> Fingers crossed :-)  Applied, thanks Zoltan.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Could you please queue this for stable as well?  It has CVE-2014-2568
assigned to it and I believe it is applicable to some of the trees.

Cheers,
--
Luís
