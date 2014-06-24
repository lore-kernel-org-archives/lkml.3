Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaFXV77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:59:59 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:35808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753223AbaFXV75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:59:57 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Topic: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Thread-Index: AQHPj7Nk2+qPLBSStUGSkQVycxbGyZuAxfWw
Date: Tue, 24 Jun 2014 21:44:14 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C98353C6@SINEX14MBXC418.southpacific.corp.microsoft.com>
References: <1403569757-2622-1-git-send-email-decui@microsoft.com>
 <20140624135101.GB10115@kroah.com>
In-Reply-To: <20140624135101.GB10115@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(448002)(24454002)(51704005)(199002)(189002)(164054003)(83072002)(54356999)(92566001)(81342001)(85852003)(4396001)(76482001)(23726002)(55846006)(50986999)(50466002)(26826002)(74502001)(76176999)(92726001)(79102001)(2656002)(107046001)(74662001)(87936001)(46102001)(33656002)(86362001)(69596002)(86612001)(68736004)(16796002)(21056001)(95666004)(6806004)(106116001)(97756001)(85326001)(84676001)(97736001)(81156004)(106466001)(80022001)(20776003)(77982001)(99396002)(44976005)(85306003)(77096002)(83322001)(81542001)(46406003)(31966008)(47776003)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0695;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=permerror (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, Jun 24, 2014 at 08:29:17AM +0800, Dexuan Cui wrote:
>> Currently the VSC has no chance to notify the VSP of the dirty rectangle on VM
>> panic because the notification work is done in a workqueue, and in panic() the
>> kernel typically ends up in an infinite loop, and a typical kernel config has
>> CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a context switch
>> can't happen in panic() and the workqueue won't have a chance to run. As a
>> result, the VM Connection window can't refresh until it's closed and we
>> re-connect to the VM.
>> 
>> We can register a handler on panic_notifier_list: the handler can notify
>> the VSC and switch the framebuffer driver to a "synchronous mode", meaning
>> the VSC flushes any future framebuffer change to the VSP immediately.
>> 
>> MS-TFS: 157532

> What is this line for?

Hi Greg,
This line is for our internal bug repository.
We have an automated system to correlate bugs with fixes so that our test
team knows when a bug fix has been accepted upstream and they need to
write a new test case for it. 

The MS-TFS line has appeared in the commit description for a while if you
search for it in 'git log'  of linux-next.

Please let us know if you have further comments.

BTW, it looks the previous patch mail was not sent properly so only part of
the people received it. I'll re-send it. Sorry for the possible confusion.

Thanks,
-- Dexuan
