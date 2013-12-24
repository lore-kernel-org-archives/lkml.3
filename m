Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3LXM2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:28:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:11110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3LXM2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,543,1384329600"; 
   d="scan'208";a="457094730"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Topic: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Index: Ac7/zXecO35CkBpaT+GTORmHLtV6Vf//wciA//4eTGA=
Date: Tue, 24 Dec 2013 12:28:05 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01A2FCD9@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01A2EDE9@SHSMSX103.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1312231003550.5503-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312231003550.5503-100000@netrider.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Monday, December 23, 2013 11:13 PM
> To: Du, ChangbinX
> Cc: gregkh@linuxfoundation.org; sarah.a.sharp@linux.intel.com; Lan, Tianyu;
> burzalodowa@gmail.com; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb/core: fix NULL pointer dereference in
> recursively_mark_NOTATTACHED
> 
> On Mon, 23 Dec 2013, Du, ChangbinX wrote:
> 
> > usb_hub_to_struct_hub() can return NULL if the hub without active
> > configuration. So the result must be checked.
> >
> > BUG: unable to handle kernel NULL pointer dereference at 0000015c

> How did you manage to trigger this BUG?  If hub is NULL then
> udev->maxchild should be 0.  See the code in hub_disconnect().
>
> Alan Stern

Hello, Alan. The hub also should be null if actconfig is null. You can see it in function
usb_hub_to_struct_hub().
udev->maxchild will be set to 0 in hub_disconnect(). But before that,
recursively_mark_NOTATTACHED may be called when calling usb_disconnect(). So this issue
will happen when usb_disconnect a hub that not have a configuration yet.
It happened once here when unplugging otg cable from DUT(will cause hcd removed) with
tiers of hub and devices. But it's not easy to reproduce it.
This is my analysis, how do you think?

Du, Changbin
