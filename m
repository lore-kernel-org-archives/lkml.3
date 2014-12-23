Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaLWFkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 00:40:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:58837 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbaLWFkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 00:40:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,629,1413270000"; 
   d="scan'208";a="628046380"
From: "Du, Changbin" <changbin.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: RE: [DISCUSSION] USB device remote wakeup is not working for S3 case
Thread-Topic: [DISCUSSION] USB device remote wakeup is not working for S3
 case
Thread-Index: AdAaujexwQVjoEsORCWW3pR7AJbQmf//tgsA//6C/XCAAwx5gP/52Muw
Date: Tue, 23 Dec 2014 05:40:37 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01C43756@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A01C42A57@SHSMSX103.ccr.corp.intel.com>
 <Pine.LNX.4.44L0.1412191020320.1599-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1412191020320.1599-100000@iolanthe.rowland.org>
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

> You have to make sure that wakeup is also enabled for the host
> controller the device is attached to.  For some host controllers, it
> may also be necessary to enable wakeup for the root hub.
> 
Yes, the root-hub is not wakeup enabled by default, actually hub
devices are not enabled. It works after I enable it via sysfs interface.

> > Could we also enable wakeup for usb mouse? Or is there any concern to
> enable it?
> > Per my opinion, most people may expect clicking mouse can awake system.
> 
> It doesn't matter to me, but you should ask the people on the
> linux-input mailing list.
> 
> Also, what about wakeup for a non-USB mouse?  Shouldn't that be enabled
> as well?
Unfortunately the mouse I found are all of usb so cannot confirm it. The
concern is if we want usb keyboard/mouse wakeup work by default, it does
make sense only if the parent hubs are also enabled by default.  This is a policy
issue and may be better place it on userspace. I have no better idea :) .

> 
> Alan Stern
Regards
Du, Changbin
