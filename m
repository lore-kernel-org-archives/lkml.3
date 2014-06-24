Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaFXOGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:06:46 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33409 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752593AbaFXOGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:06:44 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/5] xhci: Use correct SLOT ID when handling a reset
 device command
Thread-Topic: [PATCH 1/5] xhci: Use correct SLOT ID when handling a reset
 device command
Thread-Index: AQHPj7T3A3v0NA89pUGB6GqHs8HeqJuASw/w
Date: Tue, 24 Jun 2014 14:06:05 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17263160@AcuExch.aculab.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
In-Reply-To: <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Mathias Nyman
> Command completion events normally include command completion status,
> SLOT_ID, and a pointer to the original command. Reset device command
> completion SLOT_ID may be zero according to xhci specs 4.6.11.
> 
> VIA controllers set the SLOT_ID to zero, triggering a WARN_ON in the
> command completion handler.
> 
> Use the SLOT ID found from the original command instead.
> 
> This patch should be applied to stable kernels since 3.13 that contain
> the commit 20e7acb13ff48fbc884d5918c3697c27de63922a
> "xhci: use completion event's slot id rather than dig it out of command"
> 
> Cc: stable@vger.kernel.org # 3.13
> Reported-by: Saran Neti <sarannmr@gmail.com>
> Tested-by: Saran Neti <sarannmr@gmail.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-ring.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index d67ff71..71657d3 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1433,8 +1433,11 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>  		xhci_handle_cmd_reset_ep(xhci, slot_id, cmd_trb, cmd_comp_code);
>  		break;
>  	case TRB_RESET_DEV:
> -		WARN_ON(slot_id != TRB_TO_SLOT_ID(
> -				le32_to_cpu(cmd_trb->generic.field[3])));
> +		/* SLOT_ID field in reset device cmd completion event TRB is 0.

Minor nit...
Surely is would be better to say 'is undefined' or 'may be zero'.

	David



