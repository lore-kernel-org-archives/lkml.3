Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab3JPAkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:40:15 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57939 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759849Ab3JPAkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:40:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1310151615160.1377-100000@iolanthe.rowland.org>
References: <113ACA888B71994BB56E5CF3704953486D65F41155@BGMAIL02.nvidia.com>
	<Pine.LNX.4.44L0.1310151615160.1377-100000@iolanthe.rowland.org>
Date: Wed, 16 Oct 2013 08:40:11 +0800
Message-ID: <CACVXFVNoMwu6Gi3kWfz=6dm+nq=+3hFyRQGQkQZRsZ46X_ACFQ@mail.gmail.com>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vishal Annapurve <vannapurve@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 4:22 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 15 Oct 2013, Vishal Annapurve wrote:
>
>> Hi Alan,
>>
>> USB storage maybe just has to say that the abort occurred. By setting the
>> US_FLIDX_TIMED_OUT bit USB storage is getting signaled that the reason was
>> time out and the command is being aborted.
>
> No.  By setting the US_FLIDX_TIMED_OUT bit, usb-storage indicates that
> the command was aborted.  This doesn't indicate anything about the
> reason for the abort.  (Maybe this bit's name wasn't chosen very well.)
>
>> Now, it's arguable whether to change the implication of US_FLIDX_TIMED_OUT
>> bit for scsi - USB storage bridge or for entire usb storage
>
> I don't understand this.  What's the difference between "scsi - USB
> storage bridge" and "entire usb storage"?  Aren't they the same thing?
>
>>  Or maybe scsi has
>> decided to abort so it should override the result.
>
> Of course the SCSI midlayer has decided to abort.  That's the only way
> this bit can get set.  But usb-storage doesn't know why SCSI decided to
> abort.

usb-storage may know if it is caused by timeout via .eh_timed_out callback
if it wants to know.


Thanks,
-- 
Ming Lei
