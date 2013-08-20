Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3HTU6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:58:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40144 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492Ab3HTU6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:58:23 -0400
Message-ID: <1377032302.2016.75.camel@joe-AO722>
Subject: Re: [PATCH-SR9700] Merge USB 1.1 Ethernet Adapter SR9700 Device
 Driver into the Linux Kernel
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: liujunliang_ljl <liujunliang_ljl@163.com>, gregkh <gregkh@suse.de>,
        sunhecheng <sunhecheng@vip.126.com>,
        linux-usb <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 20 Aug 2013 13:58:22 -0700
In-Reply-To: <20130820204606.GB26241@electric-eye.fr.zoreil.com>
References: <201308201841116403992@163.com>
	 <20130820204606.GB26241@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 22:46 +0200, Francois Romieu wrote:
> liujunliang_ljl <liujunliang_ljl@163.com> :

> > +	if (i >= SR_SHARE_TIMEOUT) {
> > +		netdev_err(dev->net, "%s read timed out!", phy ? "phy" : "eeprom");

netdev_<level>, like almost all other printk
messages needs a terminating "\n" newline to
avoid any possible message interleaving by other
printks.

> > +	if (!is_valid_ether_addr(addr->sa_data)) {
> > +		dev_err(&net->dev, "not setting invalid mac address %pM\n",
> > +								addr->sa_data);
> 
> 		dev_err(&net->dev, "not setting invalid mac address %pM\n",
> 			addr->sa_data);

prefer netdev_<level> to dev_<level> where possible.


