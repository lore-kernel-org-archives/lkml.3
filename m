Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3KGMWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:22:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:15407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3KGMV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:21:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,651,1378882800"; 
   d="scan'208";a="423719306"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 2/8] mei: hbm: validate client index is not
 exceeding allocated array size
Thread-Topic: [char-misc-next 2/8] mei: hbm: validate client index is not
 exceeding allocated array size
Thread-Index: AQHO1P1fK4LeAfMsSUaVHro4fls3UJoM14awgABEngCADJonAA==
Date: Thu, 7 Nov 2013 12:21:54 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF073B4@HASMSX106.ger.corp.intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-3-git-send-email-tomas.winkler@intel.com>
 <20131029231945.GB30410@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AEFB95D@HASMSX106.ger.corp.intel.com>
 <20131030132748.GD30447@kroah.com>
In-Reply-To: <20131030132748.GD30447@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > This somehow should guard buffer overflow allocated of size dev-
> >me_clients_num
> > In theory this can happen only if something go wrong in hardware
> > initialization or there is some other security hole that can change
> > client_num.
> 
> What _kind_ of "security hole" could ever change that number?  Where
> does it come from?  Who can modify it?  If you don't know that now then
> we have worse problems...

The allocation of me_clients  arrays of mei_clients_num is happening on ME enumeration message,
While  the filling out the array is looping over get properties message which is bounded by MEI_CLIENTS_MAX,
so the  overflow is indeed possible, of course only on some faulty HW.  We had such errors only on new 
HW bring ups. 

Thanks
Tomas
