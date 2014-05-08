Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaEHICW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:02:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaEHICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:02:19 -0400
Date: Thu, 8 May 2014 11:01:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Adithya K <linux.challenge1@gmail.com>, standby24x7@gmail.com,
        khoroshilov@ispras.ru, arnd@arndb.de, burzalodowa@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] Staging: gdm72xx Fix minor coding style problems
Message-ID: <20140508080152.GY4963@mwanda>
References: <n>
 <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
 <1399531250.4146.12.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399531250.4146.12.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:40:50PM -0700, Joe Perches wrote:
> On Thu, 2014-05-08 at 11:53 +0530, Adithya K wrote:
> > This is patch for fixing of minor coding style problems.
> []
> > diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
> []
> > @@ -229,6 +229,7 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
> >  					entry = list_entry(
> >  					qcb->qos_list[i].prev,
> >  					struct qos_entry_s, list);
> > +
> >  					list_move_tail(&entry->list, head);
> 
> That one is a checkpatch defect.
> 
> The list_entry( use is really ugly too
> with bad indentation on the following line.
> 
> Look at the entire function:
> 
> static u32 extract_qos_list(struct nic *nic, struct list_head *head)
> {
> 	struct qos_cb_s *qcb = &nic->qos;
> 	struct qos_entry_s *entry;
> 	int i;
> 
> 	INIT_LIST_HEAD(head);
> 
> 	for (i = 0; i < QOS_MAX; i++) {
> 		if (qcb->csr[i].enabled) {
> 			if (qcb->csr[i].qos_buf_count < qcb->qos_limit_size) {
> 				if (!list_empty(&qcb->qos_list[i])) {
> 					entry = list_entry(
> 					qcb->qos_list[i].prev,
> 					struct qos_entry_s, list);
> 					list_move_tail(&entry->list, head);
> 					qcb->csr[i].qos_buf_count++;
> 
> 					if (!list_empty(&qcb->qos_list[i]))
> 						netdev_warn(nic->netdev,
> 							    "Index(%d) is piled!!\n",
> 							    i);
> 				}
> 			}
> 		}
> 	}
> 
> 	return 0;
> }
> 
> Please consider rewriting the function
> to reduce unnecessary indentation.
> 
> Something like:
> 
> static u32 extract_qos_list(struct nic *nic, struct list_head *head)
> {
> 	struct qos_cb_s *qcb = &nic->qos;
> 	int i;
> 
> 	INIT_LIST_HEAD(head);
> 
> 	for (i = 0; i < QOS_MAX; i++) {
> 		if (!qcb->csr[i].enabled ||
> 		    qcb->csr[i].qos_buf_count >= qcb->qos_limit_size)
> 			continue;
> 
> 		if (!list_empty(&qcb->qos_list[i])) {

You could flip this one around as well.

		if (list_empty(&qcb->qos_list[i])
			continue;

Move the rest in one indent level.

> 			struct qos_entry_s *entry;
> 
> 			entry = list_entry(qcb->qos_list[i].prev,
> 					   struct qos_entry_s, list);
> 			list_move_tail(&entry->list, head);
> 			qcb->csr[i].qos_buf_count++;
> 
> 			if (!list_empty(&qcb->qos_list[i]))
> 				netdev_warn(nic->netdev, "Index(%d) is piled!!\n",
> 					    i);
> 		}
> 	}

regards,
dan carpenter

