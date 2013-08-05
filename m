Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3HEIde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:33:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab3HEIdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:33:33 -0400
Date: Mon, 5 Aug 2013 16:34:45 +0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "sarah.a.sharp@linuxfoundation.org" 
	<sarah.a.sharp@linuxfoundation.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "Tang, Jianqiang" <jianqiang.tang@intel.com>,
        "Zhuang, Jin Can" <jin.can.zhuang@intel.com>,
        "Huang, Xiaochao" <xiaochao.huang@intel.com>
Subject: Re: About TRB_TO_EP_INDEX() macro using
Message-ID: <20130805083445.GA15885@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A019660C8@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A019660C8@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 08:07:25AM +0000, Du, ChangbinX wrote:
> Recently when I check xHCI code, find that some functions try to get EP index 
> from a Command Completion Event TRB via TRB_TO_EP_INDEX() macro.
> 
> This is totally wrong. The macro definition is:
> 
> 	#define TRB_TO_EP_INDEX(p)		((((p) & (0x1f << 16)) >> 16) - 1)
> 
> TRB_TO_EP_INDEX only applies to Transfer Event TRB. But for Command 
> Completion Event TRB, there is no Endpoint ID field. So, we cannot directly 
> get EP index from these TRBs, but we can find it by the TRB Pointer.
> 
> Here list two functions for you to check:
> 	handle_stopped_endpoint()
> 	handle_reset_ep_completion()

Care to send a patch showing how you would change this if it is
incorrect?

thanks,

greg k-h
