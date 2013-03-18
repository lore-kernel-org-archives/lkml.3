Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933828Ab3CRVqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:46:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3CRVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 65/75] team: unsyc the devices addresses when port is removed
Date: Mon, 18 Mar 2013 14:07:28 -0700
Message-Id: <20130318210514.956909477@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit ba81276b1a5e3cf0674cb0e6d9525e5ae0c98695 ]

When a team port is removed, unsync all devices addresses that may have
been synched to the port devices.

CC: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1139,6 +1139,8 @@ static int team_port_del(struct team *te
 	netdev_set_master(port_dev, NULL);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
+	dev_uc_unsync(port_dev, dev);
+	dev_mc_unsync(port_dev, dev);
 	dev_close(port_dev);
 	team_port_leave(team, port);
 	team_port_set_orig_dev_addr(port);


