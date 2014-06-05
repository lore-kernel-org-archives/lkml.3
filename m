Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaFEVTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:19:35 -0400
Received: from mout.web.de ([212.227.15.3]:60730 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaFEVTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:19:31 -0400
Date: Thu, 5 Jun 2014 23:20:16 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv3 net-next 0/4] bridge: multicast snooping patches /
 exports
Message-ID: <20140605212016.GE2544@Linus-Debian>
References: <1401732466-3027-1-git-send-email-linus.luessing@web.de>
 <20140602184215.GA2460@Linus-Debian>
 <20140605.004311.19890338095820543.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140605.004311.19890338095820543.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:iZ5e4ItEoc7gxb9e9tTS9kMmKVHDWbmG2Ff4ORTnuSFJKu0oJf7
 bLJgmJtmdRKjnL7CE0w8qUxmJWubNl0VZfLca1Ochru8/2MpjNXCiHsfJyEqmMTY9jikFox
 c9tssNA9IuvLtKlFVYzuMw3Fk1tcxrnTfCsXQDmbUCd3pSgKfoVvxBGDVf8ch+dpccyve8q
 Ie1c/tpvhSf9UmKbD5Bfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 05, 2014 at 12:43:11AM -0700, David Miller wrote:
> From: Linus Lüssing <linus.luessing@web.de>
> Date: Mon, 2 Jun 2014 20:42:15 +0200
> 
> > Changes in v3:
> > 
> > * use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL()
> 
> This is not a sufficient header posting.
> 
> You must also describe at a high level what this patch series is
> doing, and why you are doing it.

Oh, I'm sorry, I thought it'd only be necessary for the v1
patchset. Going to change that from now on. Anyways, here it is
(copied 'n' pasted):

-----

The first patch is simply a cosmetic patch. So far I (and maybe others
too?) have been regularly confusing these two structs, therefore I'd
suggest renaming them and therefore making the follow-up patches easier
to understand and nicer to fit in.

The second patch fixes a minor issue, but probably not worth for stable.


On the other hand the first two patches are also preparations for the
third and fourth patch:

These two patches are exporting functionality needed to marry the bridge
multicast snooping with the batman-adv multicast optimizations recently
added for the 3.15 kernel, allowing to use these optimzations in common
setups having a bridge on top of e.g. bat0, too. So far these bridged
setups would fall back to simple flooding through the batman-adv mesh
network for any multicast packet entering bat0.

More information about the batman-adv multicast optimizations currently
implemented can be found here:

http://www.open-mesh.org/projects/batman-adv/wiki/Basic-multicast-optimizations

The integration on the batman-adv side could afterwards look like this,
for instance:

http://git.open-mesh.org/batman-adv.git/commitdiff/576b59dd3e34737c702e548b21fa72059262f796?hp=f95ce7131746c65fbcdffcf2089cab59e2c2f7ac

-----
