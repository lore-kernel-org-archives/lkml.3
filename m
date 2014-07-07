Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaGGDlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:41:11 -0400
Received: from mout.web.de ([212.227.15.4]:62949 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaGGDlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:41:09 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH net-next 0/4] bridge: multicast snooping exports #2
Date: Mon,  7 Jul 2014 05:41:15 +0200
Message-Id: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:+dJDhfT99qgyfUq5D9EvjOMd3Q19AW2oAzV8efcTuuls+FsTWwv
 A2ELI6o+FuKCEi+/6dwtiy4NLT43/AAXlnJ/IZwHUwG0eZxrQEK4Ox5HnhZA3Ndm99itJPi
 H7OStim4xJNKFoG4pWSlEeEevuPfiFL2/zv9GhBU6wdsTt/mGtBLIQvduI/TlRvgBoBjR07
 UWdQSUxTU7WwTpdbLEizw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some people pointed out to me that it might be helpful to add stubs for
the newly added multicast exports. That way e.g. batman-adv should continue
to be compile and useable without having to have a kernel compiled
with bridge code in the future. This is what the first patch is supposed
to do.

The second patch adds a third multicast export for the bridge which
e.g. batman-adv is supposed to use, too, soon: Just like the bridge
disables its multicast snooping activities if no querier is present,
batman-adv needs to do the same if bridges are involved.


These three exports should be the final ones needed to marry the bridge
multicast snooping with the batman-adv multicast optimizations recently
added for the 3.15 kernel, allowing to use these optimzations in common
setups having a bridge on top of e.g. bat0, too. So far these bridged
setups would fall back to simple flooding through the batman-adv mesh
network for any multicast packet entering bat0.

More information about the batman-adv multicast optimizations currently
implemented can be found here:

http://www.open-mesh.org/projects/batman-adv/wiki/Basic-multicast-optimizations

The integration on the batman-adv side could afterwards look like this,
for instance (now including the third export):

http://git.open-mesh.org/batman-adv.git/commitdiff/61e4f6af4b7a21ed4040f2e711d50c778e5b6d93?hp=6ae4281474675fbca5bedcf768972a32db586eb6

Cheers, Linus

