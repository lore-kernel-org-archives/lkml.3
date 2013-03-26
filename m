Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3CZRps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:45:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3CZRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:21 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EHxDDWpkGVQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gzBGC_jQAMsA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=jEp0ucaQiEUA:10 a=qJl0yQZNg3oA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173613.523588054@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Pirko <jiri@resnulli.us>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 86/86] team: unsyc the devices addresses when port is removed
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0086-team-unsyc-the-devices-addresses-when-port-is-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 972ea34911d5f81639d963224d00add37170bd52 ]

When a team port is removed, unsync all devices addresses that may have
been synched to the port devices.

CC: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/team/team.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index f8cd61f..8a11070 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1008,6 +1008,8 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	netdev_set_master(port_dev, NULL);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
+	dev_uc_unsync(port_dev, dev);
+	dev_mc_unsync(port_dev, dev);
 	dev_close(port_dev);
 	team_port_leave(team, port);
 	team_port_set_orig_mac(port);
-- 
1.7.10.4


