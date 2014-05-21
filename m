Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaEUG2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:28:45 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:48173 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbaEUG2o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:28:44 -0400
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Sudarsana Kalluru" <Sudarsana.Kalluru@qlogic.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: bfa: bfa_fcs_lport.c:  Fix for possible null
 pointer dereference
Thread-Topic: [PATCH] scsi: bfa: bfa_fcs_lport.c:  Fix for possible null
 pointer dereference
Thread-Index: AQHPcrL3WnKgI+xuy0S6OQ7HkkZb25tKlh0Q
Date: Wed, 21 May 2014 06:28:31 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F8930D@avmb2.qlogic.org>
References: <1400429163-10747-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400429163-10747-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7444 signatures=670450
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1405210091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
Sent: 18 May 2014 21:36
To: Anil Gurumurthy; Sudarsana Kalluru
Cc: Rickard Strandqvist; James E.J. Bottomley; linux-scsi; linux-kernel
Subject: [PATCH] scsi: bfa: bfa_fcs_lport.c: Fix for possible null pointer dereference

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..542d5c6 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5826,12 +5826,13 @@ bfa_fcs_lport_get_rport_max_speed(bfa_fcs_lport_t *port)
        bfa_port_speed_t max_speed = 0;
        struct bfa_port_attr_s port_attr;
        bfa_port_speed_t port_speed, rport_speed;
-       bfa_boolean_t trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
+       bfa_boolean_t trl_enabled;


        if (port == NULL)
                return 0;

+       trl_enabled = bfa_fcport_is_ratelim(port->fcs->bfa);
        fcs = port->fcs;

        /* Get Physical port's current speed */
--
1.7.10.4


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
