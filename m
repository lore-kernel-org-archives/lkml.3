Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaGTGax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 02:30:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:42997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaGTGaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 02:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,694,1400050800"; 
   d="scan'208";a="459126635"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc-next 4/5] mei: nfc: clean nfc internal struct on
 host exit
Thread-Topic: [char-misc-next 4/5] mei: nfc: clean nfc internal struct on
 host exit
Thread-Index: AQHPoimjlfRLvsVCXkOX4qCYxTjx+ZuogdJA
Date: Sun, 20 Jul 2014 06:30:16 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1C379CCB@HASMSX106.ger.corp.intel.com>
References: <1405583618-8229-1-git-send-email-tomas.winkler@intel.com>
 <1405583618-8229-5-git-send-email-tomas.winkler@intel.com>
 <20140718013758.GA31846@kroah.com>
In-Reply-To: <20140718013758.GA31846@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -553,6 +553,7 @@ void mei_nfc_host_exit(struct mei_device *dev)
> >  {
> >  	struct mei_nfc_dev *ndev = &nfc_dev;
> >  	cancel_work_sync(&ndev->init_work);
> > +	memset(ndev, 0, sizeof(struct mei_nfc_dev));
> 
> This implies that something is using a "static" device structure, which
> isn't allowed by the driver core.  So please fix the root cause here,
> don't paper over the bug.
>
You are partially correct as this is not the 'struct device' it just a nfc singleton in any case it is not really nice
and  we have the fix in queue but it is rather extensive rework and  I guess it won't be suitable for stable
so hence this one liner fix.

Thanks
Tomas
 

