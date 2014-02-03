Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBCLzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:55:45 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46362 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751039AbaBCLzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:55:43 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'James Hogan'" <james.hogan@imgtec.com>
CC: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        Antonio Quartulli <antonio@meshcoding.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "oleg.drokin@intel.com" <oleg.drokin@intel.com>,
        "jacques-charles.lafoucriere@cea.fr" 
	<jacques-charles.lafoucriere@cea.fr>,
        "jinshan.xiong@intel.com" <jinshan.xiong@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-metag@vger.kernel.org" <linux-metag@vger.kernel.org>
Subject: RE: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Thread-Topic: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Thread-Index: AQHPH1WqrPdkB9hsu0CwpyENM0ZOOpqjPaqAgAARGPCAAAYjAIAAApBAgAAI3QCAAAzEgA==
Date: Mon, 3 Feb 2014 11:54:59 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B77F1@AcuExch.aculab.com>
References: <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com>
 <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda>
 <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda>
 <20140120211356.GG4815@mwanda> <52DE4DA3.7090301@imgtec.com>
 <52E3A642.7010307@gmail.com> <52ECFD53.7010401@gmail.com>
 <20140203085855.GA26722@mwanda>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B772B@AcuExch.aculab.com>
 <52EF6DCC.6040807@imgtec.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6B777A@AcuExch.aculab.com>
 <52EF7762.2060809@imgtec.com>
In-Reply-To: <52EF7762.2060809@imgtec.com>
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

From: James Hogan
> On 03/02/14 10:35, David Laight wrote:
> > From: James Hogan
> >> Combining __packed with __aligned(2) does the trick though (__packed
> >> alone sets __aligned(1) which is obviously going to be suboptimal).
...
> 
> Meta is also one of those arches, and according to my quick tests,
> __packed alone does correctly make it fall back to byte loads/stores,
> but with __packed __aligned(2) it uses 16bit loads/stores. I've also
> confirmed that with an ARM toolchain (see below for example).

I would either:
1a) Add explicit padding to the relevant structures so that they are
   multiple of 4 bytes.
or:
1b) #define some token to "__packed __aligned(2)" before all the structures
   that require changing, and use that in there definitions.
   This lets you comment on WHY you are doing it.
and:
2) Add a compile-time assert that the structures are the correct size.

Clearly you don't want to mark anything that contains a 32bit value
with __packed __aligned(2).

I'm not at all clear whether you are sometimes using a different compiler.

	David



