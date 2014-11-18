Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaKRGeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:34:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:58190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaKRGdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:33:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417982761"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Matt Fleming <matt@console-pimps.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "Sam Protsenko" <semen.protsenko@linaro.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Topic: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Index: AQHP+4de++OfUYhRjkKfGs6CqwuvNJxZipnAgArp9ICAAXTQMA==
Date: Tue, 18 Nov 2014 06:31:38 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B85DA57@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
 <20141108190655.GA2638@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
 <20141117151211.GB6810@console-pimps.org>
In-Reply-To: <20141117151211.GB6810@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Monday, November 17, 2014 11:12 PM
> >
> > - Only doing module unload is required to be aware of this synchronization
> > 	-> Ensuring the call back does not fall into unloaded code which may
> cause
> > 	     undefined behavior.
> > 	-> Ensuring the put_device() & module_put() code have finished in
> firmware_class.c
> > 	     function request_firmware_work_func() before the device is
> unregistered
> > 	     and module unloaded happen.
> 
> Shouldn't the existing module_{put,get}() and {put,get}_device() calls
> provide all the necessary synchronisation?
> 
> Module unload should not be possible while other code is using the
> module (and the module refcnt has been incremented accordindly).
> 
> Right?
> 
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

Yes, you are right. If the module refcount is not zero, you will get error
message and returned while you do "rmmod". But I strongly believe if we
have the capability in our code to take care of it by doing synchronization,
we should take care of it in case people are doing "rmmod -f". Don't
you think so?


Regards,
Wilson

