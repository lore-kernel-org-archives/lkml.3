Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3ISQnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:43:01 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:43694
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab3ISQm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:42:59 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1379607987.9148.2.camel@atx-linux-37>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Joe Perches <joe@perches.com>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Thu, 19 Sep 2013 11:26:27 -0500
In-Reply-To: <523ACB70.2020000@monstr.eu>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
	 <1379520665.1787.40.camel@joe-AO722> <523ACB70.2020000@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> +/**
> >> + * fpga_mgr_attr_read - Read data from fpga
> >> + * @dev: Pointer to the device structure
> >> + * @attr: Pointer to the device attribute structure
> >> + * @buf: Pointer to the buffer location
> >> + *
> >> + * Function reads fpga bitstream and copy them to output buffer
> >> + *
> >> + * Returns the number of bytes copied to @buf, a negative error number otherwise
> >> + */
> >> +static ssize_t fpga_mgr_attr_read(struct device *dev,
> >> +				   struct device_attribute *attr, char *buf)
> >> +{
> >> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> >> +	ssize_t count;
> >> +	int ret;
> >> +
> >> +	if (mgr && mgr->fpga_read)
> >> +		ret = mgr->fpga_read(mgr, buf, &count);
> >> +
> >> +	return ret == 0 ? count : -EPERM;
> > 
> > EPERM isn't the only error return from fpga_read.
> 
> Yeah I know. Will revisit all return codes.

Build warning:
/home/atull/repos/linux-socfpga/drivers/fpga/fpga-mgr.c:145:26: warning:
‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]


> 
> > 
> > 
> >> +/**
> >> + * fpga_mgr_attr_write - Write data to fpga
> >> + * @dev: Pointer to the device structure
> >> + * @attr: Pointer to the device attribute structure
> >> + * @buf: Pointer to the buffer location with bistream firmware filename
> >> + * @count: Number of characters in @buf
> >> + *
> >> + * @buf contains firmware filename which is loading through firmware
> >> + * interface and passed to the fpga driver.
> >> + *
> >> + * Returns string lenght added to @buf, a negative error number otherwise
> >> + */
> >> +static ssize_t fpga_mgr_attr_write(struct device *dev,
> >> +				   struct device_attribute *attr,
> >> +				   const char *buf, size_t count)
> >> +{
> >> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> >> +	int ret;
> >> +
> >> +	if (mgr && mgr->fpga_write)
> >> +		ret = mgr->fpga_write(mgr, buf);
> >> +
> >> +	return ret == 0 ? strlen(buf) : -EPERM;
> >> +}
> > 
> > Same -EPERM issue as read
> 
> yap

Build warning:
/home/atull/repos/linux-socfpga/drivers/fpga/fpga-mgr.c:236:2: warning:
‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Best Regards,
Alan



