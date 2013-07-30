Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3G3O3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:29:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:31123 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab3G3O3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,778,1367996400"; 
   d="scan'208";a="339038635"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>
Subject: RE: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-Topic: [char-misc 3.11 V2] mei: me: fix hardware reset flow
Thread-Index: AQHOjRXXO1QsMPwzCEeJTRhZuUOzTZl9E+OAgAAyL9A=
Date: Tue, 30 Jul 2013 14:28:55 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE783C8@HASMSX106.ger.corp.intel.com>
References: <1375182711-10253-1-git-send-email-tomas.winkler@intel.com>
 <20130730142209.GA28956@kroah.com>
In-Reply-To: <20130730142209.GA28956@kroah.com>
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


> Subject: Re: [char-misc 3.11 V2] mei: me: fix hardware reset flow
> 
> On Tue, Jul 30, 2013 at 02:11:51PM +0300, Tomas Winkler wrote:
> > Both H_IS and H_IE needs to be set to receive H_RDY interrupt
> >
> > 1. Assert H_IS to clear the interrupts during hw reset and use
> > mei_me_reg_write instead of mei_hcsr_set as the later strips down the
> > H_IS
> >
> > 2. fix interrupt disablement embarrassing typo
> >   hcsr |= ~H_IE -> hcsr &= ~H_IE;
> > this will remove the unwanted interrupt on power down
> >
> > 3. remove useless debug print outs
> >
> > Cc: Shuah Khan <shuah.kh@samsung.com>
> > Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> >
> > V2: Fixed typo in Shuah email
> >
> > Hope this finally resolve the ME reset issue for all
> 
> Can I get a "Tested-by:" from someone to ensure that it really does solve the
> problem?

Yes,  please wait for ack/test results. It works for me but unfortunately I cannot go over all  9 gens of  PCH and all their proliferations  where ME resides. 
I'm putting some effort to have better legacy HW testing coverage but I'm not there yet.

Thanks
Tomas 


