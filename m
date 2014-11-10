Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaKJUcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:32:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaKJUck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:32:40 -0500
Date: Mon, 10 Nov 2014 15:32:29 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: balbi@ti.com
Subject: Re: usb: dwc3: ep0: return early on NULL requests
Message-ID: <20141110203229.GA31249@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	balbi@ti.com
References: <20141101222047.7178B6610BF@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101222047.7178B6610BF@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:20:47PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=6856d30c6c0038dc0648009853533af3af6c5ba8
 > Commit:     6856d30c6c0038dc0648009853533af3af6c5ba8
 > Parent:     7d643664ea559b36188cae264047ce3c9bfec3a2
 > Refname:    refs/heads/master
 > Author:     Felipe Balbi <balbi@ti.com>
 > AuthorDate: Tue Sep 30 11:43:20 2014 -0500
 > Committer:  Felipe Balbi <balbi@ti.com>
 > CommitDate: Mon Oct 20 15:58:49 2014 -0500
 > 
 >     usb: dwc3: ep0: return early on NULL requests
 >     
 >     if our list of requests is empty, return early.

....

 > diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
 > index ae6b575..a47cc1e 100644
 > --- a/drivers/usb/dwc3/ep0.c
 > +++ b/drivers/usb/dwc3/ep0.c
 > @@ -789,9 +789,6 @@ static void dwc3_ep0_complete_data(struct dwc3 *dwc,
 >  
 >  	dwc->ep0_next_event = DWC3_EP0_NRDY_STATUS;
 >  
 > -	r = next_request(&ep0->request_list);
 > -	ur = &r->request;
 > -
 >  	trb = dwc->ep0_trb;

 
Since the deletion of this assignment to 'r', we're now doing
a comparison on it, resulting in dead code that will never be
reached..

** CID 1251381:  Logically dead code  (DEADCODE)
/drivers/usb/dwc3/ep0.c: 799 in dwc3_ep0_complete_data()


________________________________________________________________________________________________________
*** CID 1251381:  Logically dead code  (DEADCODE)
/drivers/usb/dwc3/ep0.c: 799 in dwc3_ep0_complete_data()
793
794             status = DWC3_TRB_SIZE_TRBSTS(trb->size);
795             if (status == DWC3_TRBSTS_SETUP_PENDING) {
796                     dwc3_trace(trace_dwc3_ep0, "Setup Pending received");
797
798                     if (r)
>>>     CID 1251381:  Logically dead code  (DEADCODE)
>>>     Execution cannot reach this statement: "dwc3_gadget_giveback(ep0, r...".
799                             dwc3_gadget_giveback(ep0, r, -ECONNRESET);
800
801                     return;
802             }
803
804             r = next_request(&ep0->request_list);

Picked up by Coverity scan.

	Dave

