Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3IPPJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:09:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16523 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IPPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:09:38 -0400
Date: Mon, 16 Sep 2013 18:05:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vojtech@suse.cz" <vojtech@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/1] Drivers: input: serio: New driver to support Hyper-V
 synthetic keyboard
Message-ID: <20130916150548.GO25896@mwanda>
References: <1379309334-25042-1-git-send-email-kys@microsoft.com>
 <20130916082110.GN25896@mwanda>
 <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b5096d0190b4440a8e25afbd22ab72d@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 02:46:24PM +0000, KY Srinivasan wrote:
> > > +			case VM_PKT_DATA_INBAND:
> > > +				hv_kbd_on_receive(device, desc);
> > 
> > This is the error handling I mentioned at the top.  hv_kbd_on_receive()
> > doesn't take into consideration the amount of data we recieved, it
> > trusts the offset we recieved from the user.  There is an out of bounds
> > read.
> 
> What user are you referring to. The message is sent by the host - the user keystroke
> is normalized into a fixed size packet by the host and sent to the  guest. We will parse this
> packet, based on the host specified layout here.
> 

The user means the hypervisor, yes.

I don't want the hypervisor accessing outside of the buffer.  It is
robustness issue.  Just check the offset against "bytes_recvd".  It's
not complicated.

If you have a different place where the guest does this then tell me
which function to look at.

regards,
dan carpenter
