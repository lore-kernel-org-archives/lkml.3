Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3IBAk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:40:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab3IBAk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:40:26 -0400
Date: Sun, 1 Sep 2013 17:40:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 3/3] extcon: Simplify extcon_dev_register() prototype by
 removing unnecessary parameter
Message-ID: <20130902004024.GB10709@kroah.com>
References: <1378081208-20274-1-git-send-email-cw00.choi@samsung.com>
 <1378081208-20274-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378081208-20274-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 09:20:08AM +0900, Chanwoo Choi wrote:
> This patch remove extcon_dev_register()'s second parameter which means
> the pointer of parent device to simplify prototype of this function.

No, please don't.  You want the parent to be passed in, as the core
needs it when it is registered with the system, otherwise it will not
show up in sysfs properly (i.e. you can't set it afterwards.)

> So, if extcon device has the parent device, it should set the pointer of
> parent device to edev.dev.parent in extcon device driver instead of in
> extcon_dev_register().

No it will break things if you do that :(

greg k-h
