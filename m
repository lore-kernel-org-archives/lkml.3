Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3JORx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:53:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19701 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab3JORx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:53:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 10:53:55 -0700
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Tue, 15 Oct 2013 23:23:50 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7JyGJZFCxx1CqxQfqneoJlA2TvmwABCsEw
Message-ID: <113ACA888B71994BB56E5CF3704953486D65F41155@BGMAIL02.nvidia.com>
References: <113ACA888B71994BB56E5CF3704953486D65F41133@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1310151258560.1377-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310151258560.1377-100000@iolanthe.rowland.org>
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

USB storage maybe just has to say that the abort occurred. By setting the
US_FLIDX_TIMED_OUT bit USB storage is getting signaled that the reason was
time out and the command is being aborted.
 
Now, it's arguable whether to change the implication of US_FLIDX_TIMED_OUT
bit for scsi - USB storage bridge or for entire usb storage Or maybe scsi has
decided to abort so it should override the result.

Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu] 
Sent: Tuesday, October 15, 2013 7:03 PM
To: Vishal Annapurve
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

On Tue, 15 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> This issue seems more related to the devices using SCSI protocol and 
> the changes otherwise will be at more places giving the same end result.
> 
> I think as the comment says over the command_abort function, 
> intentional result change should only happen in case of timeout.

usb-storage doesn't know _why_ a command was aborted; it knows only that the abort occurred.

If you look carefully at the code, you'll see that the result is set to DID_ABORT only when the US_FLIDX_TIMED_OUT bit is set, and this bit gets set only when a SCSI abort occurs.

Alan Stern

