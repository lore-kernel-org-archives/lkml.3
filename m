Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaF3ImU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:42:20 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50912 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752672AbaF3ImS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:42:18 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Richard Leitner'" <richard.leitner@skidata.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Thread-Topic: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Thread-Index: AQHPlD5SSygGtgUtdESncUl0Nvmcr5uJVOuQ
Date: Mon, 30 Jun 2014 08:41:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726930B@AcuExch.aculab.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
 <20140630103616.620a13a2@lxbuild.skidata.net>
In-Reply-To: <20140630103616.620a13a2@lxbuild.skidata.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Richard Leitner
> Replaces all hardcoded ttyGS strings with the PREFIX macro.
> Due to the fact the strings are spread over different source files the
> PREFIX definition is moved to u_serial.h

Lots of changes like:
> -		DBG(cdev, "acm ttyGS%d completion, err %d\n",
> -				acm->port_num, req->status);
> +		DBG(cdev, "acm %s%d completion, err %d\n",
> +				PREFIX, acm->port_num, req->status);

I'm not sure this improves the code.
Do you see a need to ever change PREFIX?

Even if it is a reasonable change, the name PREFIX is hopeless.
It would have to be something like ACM_TTYNAME_PREFIX.

	David



