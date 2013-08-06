Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3HFI7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:59:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:33032 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab3HFI7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:59:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,825,1367996400"; 
   d="scan'208";a="376823273"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "sarah.a.sharp@linuxfoundation.org" 
	<sarah.a.sharp@linuxfoundation.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "Tang, Jianqiang" <jianqiang.tang@intel.com>,
        "Zhuang, Jin Can" <jin.can.zhuang@intel.com>,
        "Huang, Xiaochao" <xiaochao.huang@intel.com>
Subject: RE: About TRB_TO_EP_INDEX() macro using
Thread-Topic: About TRB_TO_EP_INDEX() macro using
Thread-Index: Ac6Sg0GZ085UJTe5Qx+1GaQBy5LScg==
Date: Tue, 6 Aug 2013 08:59:32 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01966F92@SHSMSX103.ccr.corp.intel.com>
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

> On Mon, Aug 05, 2013 at 08:07:25AM +0000, Du, ChangbinX wrote:
> > Recently when I check xHCI code, find that some functions try to get EP index
> > from a Command Completion Event TRB via TRB_TO_EP_INDEX() macro.
> >
> > This is totally wrong. The macro definition is:
> >
> > 	#define TRB_TO_EP_INDEX(p)		((((p) & (0x1f << 16)) >> 16) - 1)
> >
> > TRB_TO_EP_INDEX only applies to Transfer Event TRB. But for Command
> > Completion Event TRB, there is no Endpoint ID field. So, we cannot directly
> > get EP index from these TRBs, but we can find it by the TRB Pointer.
> >
> > Here list two functions for you to check:
> > 	handle_stopped_endpoint()
> > 	handle_reset_ep_completion()
> 
> Care to send a patch showing how you would change this if it is
> incorrect?
> 
> thanks,
> 
> greg k-h
> --

Hello, Greg k-h. I am not very sure about this issue. If this is true, kernel will panic when 
invoking above functions. I want someone help to confirm if I miss something. If it's really 
a bug, I will work out a patch to fix it.
