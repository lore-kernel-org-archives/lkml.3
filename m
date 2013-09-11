Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3IKWIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 18:08:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:4685 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3IKWIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 18:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,887,1371106800"; 
   d="scan'208";a="359180002"
From: "Johnston, DJ" <dj.johnston@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, David Safford <safford@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, "Rajiv Andrade" <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Ted Ts'o" <tytso@mit.edu>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: RE: TPMs and random numbers
Thread-Topic: TPMs and random numbers
Thread-Index: AQHOrxOJBGCugV8ERESrS0XX9O3pdJnBRdyA///SBBA=
Date: Wed, 11 Sep 2013 22:08:45 +0000
Message-ID: <B224219ACFE22C4E861330F94D462E156B780C6F@ORSMSX107.amr.corp.intel.com>
References: <1378920168.26698.64.camel@localhost>
 <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
In-Reply-To: <CALCETrVgiJuw9vj+BhchgzAH06gqEO4TYJyt8wd+2CCy33RQ3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	

>-----Original Message-----
>From: Andy Lutomirski [mailto:luto@amacapital.net] 

>A TPM that has an excellent internal entropy source and is FIPS 140-2 compliant with no bugs whatsoever may still use Dual_EC_DRBG, which looks increasingly likely to be actively malicious.

You can look up the FIPS certification to see which algorithms were approved. The Dual_EC_DRBG always looked suspect to me, which is one reason why it wasn't used in RdRand. The other is that the core crypto function doesn't do dual duty as an entropy extractor like AES hardware does with AES-CBC-MAC and AES-CTR-DRBG.
 
DJ

