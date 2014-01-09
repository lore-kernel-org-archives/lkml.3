Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbaAIVFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:05:15 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:1689
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaAIVFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:05:09 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPDMVZ9zrtMOoYp0KOm7oSIbZbR5p8AmiAgAC00tCAAByZgIAADLTg
Date: Thu, 9 Jan 2014 21:05:05 +0000
Message-ID: <1f59f9753bec413888cc96972e0f2dd2@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109073949.GR30234@mwanda>
 <540ecdf5cf6b47d79583f4f97788e3f0@BY2PR03MB299.namprd03.prod.outlook.com>
 <20140109200921.GT30234@mwanda>
In-Reply-To: <20140109200921.GT30234@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.216]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(51704005)(199002)(189002)(13464003)(92566001)(81686001)(66066001)(54356001)(551934002)(51856001)(59766001)(77982001)(79102001)(54316002)(46102001)(56776001)(76482001)(53806001)(81816001)(80022001)(65816001)(63696002)(74876001)(85306002)(74316001)(90146001)(56816005)(33646001)(85852003)(74366001)(83072002)(87936001)(2656002)(74706001)(76576001)(76786001)(76796001)(87266001)(4396001)(49866001)(47736001)(47976001)(50986001)(81542001)(80976001)(19580405001)(19580395003)(83322001)(69226001)(74662001)(47446002)(81342001)(74502001)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, January 09, 2014 12:09 PM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; apw@canonical.com; devel@linuxdriverproject.org
> Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
> 
> We've had this discussion before where you urge me to trust the host...

I am just implementing the protocol specification given by the host. If I cannot trust the
specified protocol, I am not sure what else can be done here. 

> 
>  Problem: This code is racy.
> Solution: The host will only send one message at a time.

The code is not racy given the protocol that is specified. While I could have 
blindly trusted the host, this driver code actually reads only one packet at a time.
When we get a transaction from the host, we do not process any more transactions until
the current transaction is fully processed. So what is the race condition here?

> 
> Now I have to audit the user space code on the host and I don't feel
> like doing that so you win.

I don't think you need to audit any code.

> 
> I wish we had a better way to do IPC.  If kdbus were ready, that might
> have worked for this, and it's a better solution because both sender and
> reciever code will be written in a less trusting way.

I am not sure how kdbus would help you here. We are talking about communicating
between the host and the guest here. 

K. Y
> 
> regards,
> dan carpenter

