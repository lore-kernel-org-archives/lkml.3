Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab3FFH5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:57:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:42510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab3FFH5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,813,1363158000"; 
   d="scan'208";a="325110239"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [char-misc 3.10] mei: nfc: fix nfc device freeing
Thread-Topic: [char-misc 3.10] mei: nfc: fix nfc device freeing
Thread-Index: AQHOYCP4vXhyWS6zykSnP/S3A5AVF5kj2jcAgAR6IlA=
Date: Thu, 6 Jun 2013 07:57:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B028BCE64@HASMSX106.ger.corp.intel.com>
References: <1370240910-16411-1-git-send-email-tomas.winkler@intel.com>
 <20130603142654.GD7024@kroah.com>
In-Reply-To: <20130603142654.GD7024@kroah.com>
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
> On Mon, Jun 03, 2013 at 09:28:30AM +0300, Tomas Winkler wrote:
> > The nfc_dev is a static variable and is not cleaned properly upon
> > reset mainly ndev->cl and ndev->cl_info are not set to NULL after
> > freeing which
> 
> Then it needs to be made dynamic, don't paper over the bug by zeroing it
> out, you really have a much larger issue here that just hasn't hit you yet.
> 
> No 'struct device' should ever be in a static variable, please fix this properly.

Greg,  I was looking into it and as in realistic configuration is we are fine as there is only one possible MEI NFC device on whole system.
nfc_dev is also not 'a struct device' type is a singleton then holds NFC configuration.
Currently changing the behavior would require rather a larger fix and this oneliner  effectively fixes the crash.

I don't mind to fix it properly but we are already in rc3, let us know what path to go. 

Thanks
Tomas
 

