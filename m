Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3D1MQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 08:16:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53138 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3D1MQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 08:16:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 28 Apr 2013 14:15:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] firewire: Fix 'failed to read phy reg' on FW643 rev8
Message-ID: <20130428141559.0439c881@stein>
In-Reply-To: <1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
References: <1364306830.12229.14.camel@thor.lan>
	<1364307560-27601-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 26 Peter Hurley wrote:
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -2268,8 +2268,8 @@ static int ohci_enable(struct fw_card *card,
>  		  OHCI1394_HCControl_postedWriteEnable);
>  	flush_writes(ohci);
>  
> -	for (lps = 0, i = 0; !lps && i < 3; i++) {
> -		msleep(50);
> +	for (lps = 0, i = 0; !lps && i < 150; i++) {
> +		msleep(1);
>  		lps = reg_read(ohci, OHCI1394_HCControlSet) &
>  		      OHCI1394_HCControl_LPS;
>  	}

This duplicates a mistake (?) that we already did a few times elsewhere in
firewire-ohci:  msleep(1) may put the thread to sleep for much, much longer
than 1 millisecond.  I will propose a patch soon.
-- 
Stefan Richter
-=====-===-= -=-- ===--
http://arcgraph.de/sr/
