Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbaAGJQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:16:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:14028 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaAGJQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:16:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="461263416"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "'sarah.a.sharp@linux.intel.com'" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "'burzalodowa@gmail.com'" <burzalodowa@gmail.com>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Topic: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
Thread-Index: Ac7/zXecO35CkBpaT+GTORmHLtV6Vf//wciA//4eTGCAA+P8AIABIPeA//7BKBD//Q550AIhRpOA//8PpJD/91vSUA==
Date: Tue, 7 Jan 2014 09:16:42 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01A369D2@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01A31B4E@SHSMSX103.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1401021417030.892-100000@iolanthe.rowland.org>
 <0C18FE92A7765D4EB9EE5D38D86A563A01A34C18@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A34C18@SHSMSX103.ccr.corp.intel.com>
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

> > Changbin, after looking more closely I realized there was a second
> > aspect to this race: recursively_mark_NOTATTACHED uses hub->ports[i]
> > while hub_disconnect removes the port devices.  You ought to be able
> > to cause an oops by inserting a delay just after the loop where
> > usb_hub_remove_port_device is called.
> >
> > The updated patch below should fix both problems.  Can you test it?
> >
> > Alan Stern
> >
> 
> Ok, I'll test it today or tomorrow. Please wait my response.

Alan, I cannot cause a panic after inserting a delay just after 
usb_hub_remove_port_device is called, even move the delay after 
kfree(hub->ports). recursively_mark_NOTATTACHED will not access 
hub->ports[i] since maxchild has been set to 0.

Alan, I think your last patch can fix this issue. 
