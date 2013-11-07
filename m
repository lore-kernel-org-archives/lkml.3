Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3KGAaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:30:06 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50442 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3KGAaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:30:04 -0500
Date: Thu, 7 Nov 2013 09:29:59 +0900
From: "tj@kernel.org" <tj@kernel.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
Message-ID: <20131107002959.GA32200@mtj.dyndns.org>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
 <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Liu.

On Thu, Nov 07, 2013 at 12:27:56AM +0000, Liu, Chuansheng wrote:
> The driver code is as below:
> _INIT() {
> 
> A = devm_kzalloc();
> B= devm_request_threaded_irq(isr_handler);
> C = devm_kzalloc();
> }
> 
> When driver _EXIT, the devres_release_all () will be called.
> The C will be kfreed before B, but when freeing irq B, the pending isr_handler() possibly
> will access the memory B which has been freed.
> Then the memory corruption occurred.
> 
> This patch can solve this scenario.

Isn't the bug there IRQ being requested before all its resources are
allocated?  The proposed change just masks the underlying issue or
incorrectly ordered operations.

Thanks.

-- 
tejun
