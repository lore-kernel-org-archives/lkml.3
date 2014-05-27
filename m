Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaE0Ii5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:38:57 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:1139 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbaE0Ii4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:38:56 -0400
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Benoit Taine <benoit.taine@lip6.fr>
CC: Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 4/18] qla4xxx: Use kmemdup instead of kmalloc + memcpy
Thread-Topic: [PATCH 4/18] qla4xxx: Use kmemdup instead of kmalloc + memcpy
Thread-Index: AQHPePYlgijUvmhmgEidfvbMQNO+4ZtU7asA
Date: Tue, 27 May 2014 08:38:21 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD8C6AE268@avmb3.qlogic.org>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
 <1401117687-28911-5-git-send-email-benoit.taine@lip6.fr>
In-Reply-To: <1401117687-28911-5-git-send-email-benoit.taine@lip6.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FCD91A72DABCAF49B381B23A4552EF44@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7450 signatures=670455
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1405270119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/05/14 8:51 pm, "Benoit Taine" <benoit.taine@lip6.fr> wrote:

>This issue was reported by coccicheck using the semantic patch
>at scripts/coccinelle/api/memdup.cocci
>
>Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
>---
>Tested by compilation without errors.
>
> drivers/scsi/qla4xxx/ql4_os.c |    7 +++----
> 1 file changed, 3 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 9eef7d4..3202063 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -3565,14 +3565,13 @@ static int qla4xxx_copy_from_fwddb_param(struct
>iscsi_bus_flash_session *sess,
> 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
> 		conn->ipv6_traffic_class = fw_ddb_entry->ipv4_tos;
> 
>-		conn->link_local_ipv6_addr = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
>+		conn->link_local_ipv6_addr = kmemdup(
>+					fw_ddb_entry->link_local_ipv6_addr,
>+					IPv6_ADDR_LEN, GFP_KERNEL);
> 		if (!conn->link_local_ipv6_addr) {
> 			rc = -ENOMEM;
> 			goto exit_copy;
> 		}
>-
>-		memcpy(conn->link_local_ipv6_addr,
>-		       fw_ddb_entry->link_local_ipv6_addr, IPv6_ADDR_LEN);
> 	} else {
> 		conn->ipv4_tos = fw_ddb_entry->ipv4_tos;
> 	}

Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
 

