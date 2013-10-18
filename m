Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3JRFii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 01:38:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14923 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3JRFig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 01:38:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 22:34:06 -0700
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Fri, 18 Oct 2013 11:08:31 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7J5EHq/CUl25Z8Qbupr6VMcDX31wB3P5+w
Message-ID: <113ACA888B71994BB56E5CF3704953486D65F41715@BGMAIL02.nvidia.com>
References: <113ACA888B71994BB56E5CF3704953486D65F41155@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1310151615160.1377-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310151615160.1377-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

What I wanted to say was If the bit US_FLIDX_TIMED_OUT can have more
meanings than timed out then maybe it would be best to override the
results after usb-storage is done with the command maybe in scsi layer
itself who aborted it in the first place.

My concern was that overriding the result in usb storage or scsi layers
will have more side effects than doing it in scsiglue.c.
And by scsi-usb storage bridge what I meant was specifically the code in 
scsiglue.

Question about your last mail, do you want to change all the occurrences of
DID_ABORT from usb-storage to DID_TIMEOUT?

Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu] 
Sent: Tuesday, October 15, 2013 10:22 PM
To: Vishal Annapurve
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

On Tue, 15 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> USB storage maybe just has to say that the abort occurred. By setting 
> the US_FLIDX_TIMED_OUT bit USB storage is getting signaled that the 
> reason was time out and the command is being aborted.

No.  By setting the US_FLIDX_TIMED_OUT bit, usb-storage indicates that the command was aborted.  This doesn't indicate anything about the reason for the abort.  (Maybe this bit's name wasn't chosen very well.)

> Now, it's arguable whether to change the implication of 
> US_FLIDX_TIMED_OUT bit for scsi - USB storage bridge or for entire usb 
> storage

I don't understand this.  What's the difference between "scsi - USB storage bridge" and "entire usb storage"?  Aren't they the same thing?

>  Or maybe scsi has
> decided to abort so it should override the result.

Of course the SCSI midlayer has decided to abort.  That's the only way this bit can get set.  But usb-storage doesn't know why SCSI decided to abort.

Alan Stern

