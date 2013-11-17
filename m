Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3KQQxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:53:39 -0500
Received: from mout.gmx.net ([212.227.17.22]:49666 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab3KQQxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:53:33 -0500
Date: Sun, 17 Nov 2013 17:53:29 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117165329.GA1562@thinkpad.fritz.box>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
 <20131117110846.GA3093@katana>
 <20131117123902.GA3834@awedesk.fritz.box>
 <20131117121809.GC3093@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117121809.GC3093@katana>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Provags-ID: V03:K0:X8R6+4NvA09JE9zC/hZ6DaeGtR3xPCha6bmp6fdsIOXXcSHK8Li
 GO8FRpazAQsWZblP04dZ7dLxqoQ7KAvyUlb88Hsefjud+h1RmDI8FZMSYxtm9li8pFYD3KW
 SE9FZEMrJi+eka35HTsewjZras6MoDBlUMYvUopGxDqz6m9WW9UT7k90x+0z9aw383PH8ia
 +2/QBKYTiyMllmPIGhjmw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 01:18:09PM +0100, Wolfram Sang wrote:
> 
> > Is there another reason why pch_i2c_getack returned EPROTO?
> > May be ENXIO was introduced later?
> 
> Imperfect review :)
> 
> > I think we can just replace the -EIO with -ENXIO or do you want to pick up the return
> > vale of pch_i2c_getack and return that ?
> 
> The latter. As a rule of thumb, it is usually more sustainable to pass
> through error codes. Overloading them should only be done when really
> necessary IMO.
> 
Ok, if that will be ok in pch_i2c_wait_for_check_xfer i will resend 
the patch.

        ret = pch_i2c_getack(adap);

        if (ret)
                pch_dbg(adap, "Receive NACK for slave address setting\n");

        return (int)ret;

Regards 
Andy
