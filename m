Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaFGQ07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:26:59 -0400
Received: from mout.web.de ([212.227.17.12]:62401 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbaFGQZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:25:59 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv4 net-next 0/4] bridge: multicast snooping patches / exports
Date: Sat,  7 Jun 2014 18:26:25 +0200
Message-Id: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:dWZopU4ZALWgQMpKvb4D2xu9VzjRLGhRLwOxbu6hhjVr974F8MG
 McuiyuF8Q+KHEMNKnMeiJTNs6oBvxLdNZrjMPkVBmXLjnjeKHDzFLBZZVpfj1vDgBq9AsUi
 rNdPCB/BX51aQfQu7TORPu+1NSA1QSQTtVXaXPtMWrA8AmZK3/nGbeypnetM+h6rJ1lhiIZ
 mzrhCnDupTeqG41QmlPQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Changes in v4:
 - merged header postings from all previous patchset versions

Changes in v3:
 - use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL()

Changes in v2:
 - fix a nasty typo in PATCH 1/4, br_multicast_update_query_timer():
   "br->multicast_query_interval" vs. "br->multicast_querier_interval"
   => this accidentally reduced the other querier present timer 
      from 255 to 125 seconds
 - fix a typo in PATCH 2/4, br_ip{4,6}_multicast_query():
   ntohs(ETH_P_{IP,IPV6}) vs. htons(ETH_P_{IP,IPV6})
 - add missing ntohl()s before address comparison in PATCH 2/4,
   br_ip4_multicast_select_querier() (thanks David!)

Cheers, Linus

