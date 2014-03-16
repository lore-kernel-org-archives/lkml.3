Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaCPWTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 18:19:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:23682 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbaCPWTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 18:19:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,666,1389772800"; 
   d="scan'208";a="493234912"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Joe Perches <joe@perches.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 2/5] mei: use cl_dbg where appropriate
Thread-Topic: [char-misc-next 2/5] mei: use cl_dbg where appropriate
Thread-Index: AQHPQTXgCJryxSXUv0uyuYOpihQ3QZrkNFgw
Date: Sun, 16 Mar 2014 22:19:39 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFA02E5@HASMSX106.ger.corp.intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
	 <1394973358-21690-3-git-send-email-tomas.winkler@intel.com>
 <1394987781.5689.23.camel@joe-AO722>
In-Reply-To: <1394987781.5689.23.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Sun, 2014-03-16 at 14:35 +0200, Tomas Winkler wrote:
> > use cl_dbg for debug log messages in cl context
> 
> I think all the uses of cl_dbg and cl_err are odd.
> 
> from: client.h
> 
> #define cl_dbg(dev, cl, format, arg...) \
> 	dev_dbg(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl),
> ##arg)
> 
> #define cl_err(dev, cl, format, arg...) \
> 	dev_err(&(dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl), ##arg)
> 
> dev is always passed separately from cl but
> dev is set like:
> 
> 	struct mei_device *dev;
> []
> 	dev = cl->dev;
> 
> So I think these should be converted to:
> 
> #define cl_dbg(cl, format, ...) \
> 	dev_dbg(&(cl)->dev)->pdev->dev, MEI_CL_FMT format, MEI_CL_PRM(cl),
> ##__VA_ARGS__)
> 
> and the uses from (as an example):
> 
> client.c:942:			cl_dbg(dev, cl, "Waking up reading client!\n");
> 
> to
> 
> client.c:942:			cl_dbg(cl, "Waking up reading client!\n");
> 
> This can also remove some used once declarations of dev

Yes, I'm aware of this, at the time I've preferred consistently passing dev as a first argument. 
It can be changed I just  personally  don't feel some big gain.

Tomas



