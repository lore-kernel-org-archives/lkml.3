Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958Ab3BGW5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:57:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:4599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945894Ab3BGW5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:57:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="288041265"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 05/11] mei: bus: Call bus routines from the
 core code
Thread-Topic: [char-misc-next 05/11] mei: bus: Call bus routines from the
 core code
Thread-Index: AQHOBYPF6T1CsSPK8UmdeZ0W5LF5OJhvAHCQ
Date: Thu, 7 Feb 2013 22:57:28 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EC3BB6@HASMSX106.ger.corp.intel.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-6-git-send-email-tomas.winkler@intel.com>
 <201302072237.31048.arnd@arndb.de>
In-Reply-To: <201302072237.31048.arnd@arndb.de>
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



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 08, 2013 00:38
> To: Winkler, Tomas
> Cc: gregkh@linuxfoundation.org; sameo@linux.intel.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [char-misc-next 05/11] mei: bus: Call bus routines from the core
> code
> 
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > @@ -197,6 +197,9 @@ static int mei_probe(struct pci_dev *pdev, const
> struct pci_device_id *ent)
> >         mei_pdev = pdev;
> >         pci_set_drvdata(pdev, dev);
> >
> > +       err = mei_bus_init(mei_pdev);
> > +       if (err)
> > +               goto deregister_mei;
> >
> >         schedule_delayed_work(&dev->timer_work, HZ);
> >
> 
> This is fairly unusual, and will break if you ever have multiple mei devices in
> one system, because you end up registering the bus type for each device. I
> think it would be more logical to register/unregister the bus_type from the
> module_init/exit functions of the module that contains the bus_type object.

MEI is a singleton and it is enforced also in software in the probe 

Second why to register anything if the MEI device is not present on the system. 

Thanks
Tomas

