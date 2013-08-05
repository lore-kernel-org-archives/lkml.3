Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3HEIHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:07:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:57486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3HEIH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,816,1367996400"; 
   d="scan'208";a="376243090"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "sarah.a.sharp@linuxfoundation.org" 
	<sarah.a.sharp@linuxfoundation.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "Tang, Jianqiang" <jianqiang.tang@intel.com>,
        "Zhuang, Jin Can" <jin.can.zhuang@intel.com>,
        "Huang, Xiaochao" <xiaochao.huang@intel.com>
Subject: About TRB_TO_EP_INDEX() macro using
Thread-Topic: About TRB_TO_EP_INDEX() macro using
Thread-Index: Ac6RstFtOlwuIZkPS2GOcAkgTF+4sQ==
Date: Mon, 5 Aug 2013 08:07:25 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A019660C8@SHSMSX103.ccr.corp.intel.com>
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

Recently when I check xHCI code, find that some functions try to get EP index 
from a Command Completion Event TRB via TRB_TO_EP_INDEX() macro.

This is totally wrong. The macro definition is:

	#define TRB_TO_EP_INDEX(p)		((((p) & (0x1f << 16)) >> 16) - 1)

TRB_TO_EP_INDEX only applies to Transfer Event TRB. But for Command 
Completion Event TRB, there is no Endpoint ID field. So, we cannot directly 
get EP index from these TRBs, but we can find it by the TRB Pointer.

Here list two functions for you to check:
	handle_stopped_endpoint()
	handle_reset_ep_completion()

Regards & Thanks!
Changbin


