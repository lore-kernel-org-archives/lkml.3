Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaDGVkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:40:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:23986 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaDGVkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,812,1389772800"; 
   d="scan'208";a="488773771"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Topic: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Index: AQHPS0iuvgiDnehMNEeghRTCX5Z79Jr4hhDwgAJi2QCAADLdEIADEokAgAA5rQD//9ENgIAH8M5Q///W/gCAAI6bcA==
Date: Mon, 7 Apr 2014 19:01:25 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7512@HASMSX106.ger.corp.intel.com>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
 <20140407132530.GF3339@pcnci.linuxbox.cz>
In-Reply-To: <20140407132530.GF3339@pcnci.linuxbox.cz>
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



> -----Original Message-----
> From: Nikola Ciprich [mailto:nikola.ciprich@linuxbox.cz]
> Sent: Monday, April 07, 2014 16:26
> To: Winkler, Tomas
> Cc: Greg KH (gregkh@linuxfoundation.org); linux-kernel@vger.kernel.org; Nikola
> Ciprich
> Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
> 
> Hi Tomas,
> 
> yes, I just checked source rpm and it's applied..
> 
> here are the dumps:
> 
> [root@k310test ~]# hexdump -s 0x48 -n 4 /proc/bus/pci/00/16.0
> 0000048 a301 3900
> 000004c
> [root@k310test ~]# hexdump -s 0x40 -n 4 /proc/bus/pci/00/16.0
> 0000040 0345 000f
> 0000044

I'm not sure how this is possible that this is failing for you

if ((0xa301 & 0x600) == 0x200)
	goto no_mei; 
so this is okay, the driver should not bind

How the patch worked for you before this test?  

Sorry for asking but can you please double check your compilation setup. 
 
Thanks
Tomas
