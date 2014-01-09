Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaAIGvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 01:51:18 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60888 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaAIGvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 01:51:12 -0500
Message-ID: <52CE46CE.2030903@cs.wisc.edu>
Date: Thu, 09 Jan 2014 00:50:54 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi: fix wrong order of opcode and itt in iscsi_handle_reject
 prompt
References: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
In-Reply-To: <1389234094-6134-1-git-send-email-vaughan.cao@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 08:21 PM, Vaughan Cao wrote:
> This patch makes reject messages show right value for opcode and itt, which
> is converse previously.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index e399561..27547ff 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1013,13 +1013,13 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected "
>  				  "due to DataDigest error.\n",
> -				  rejected_pdu.itt, opcode);
> +				  opcode, rejected_pdu.itt);
>  		break;
>  	case ISCSI_REASON_IMM_CMD_REJECT:
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected. Too many "
>  				  "immediate commands.\n",
> -				  rejected_pdu.itt, opcode);
> +				  opcode, rejected_pdu.itt);
>  		/*
>  		 * We only send one TMF at a time so if the target could not
>  		 * handle it, then it should get fixed (RFC mandates that
> @@ -1059,8 +1059,8 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  	default:
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "pdu (op 0x%x itt 0x%x) rejected. Reason "
> -				  "code 0x%x\n", rejected_pdu.itt,
> -				  rejected_pdu.opcode, reject->reason);
> +				  "code 0x%x\n", rejected_pdu.opcode,
> +				  rejected_pdu.itt, reject->reason);
>  		break;
>  	}
>  	return rc;
> 

Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
