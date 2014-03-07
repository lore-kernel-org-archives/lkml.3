Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaCGG6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 01:58:36 -0500
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:23788
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751016AbaCGG6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 01:58:34 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
 of pfns we can handle
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the
 number of pfns we can handle
Thread-Index: AQHPOc2oQ3eOFqZTbkO5srnGB9wLTZrVLvuAgAAAIHA=
Date: Fri, 7 Mar 2014 06:58:30 +0000
Message-ID: <b484d406499b496bad392a56da7766d5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394176508-1439-1-git-send-email-kys@microsoft.com>
 <20140307064849.GB20065@kroah.com>
In-Reply-To: <20140307064849.GB20065@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.216.132.197]
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(199002)(189002)(24454002)(377454003)(59766001)(77982001)(31966008)(65816001)(87266001)(79102001)(47446002)(95416001)(86362001)(74662001)(74876001)(74502001)(85306002)(97186001)(97336001)(80022001)(94946001)(76786001)(47976001)(33646001)(93516002)(92566001)(46102001)(81816001)(76576001)(50986001)(19580405001)(66066001)(85852003)(19580395003)(74316001)(69226001)(80976001)(47736001)(49866001)(81686001)(87936001)(51856001)(2656002)(56816005)(81342001)(94316002)(93136001)(83322001)(63696002)(56776001)(76796001)(74366001)(95666003)(86612001)(54356001)(81542001)(83072002)(54316002)(76482001)(90146001)(74706001)(4396001)(53806001)(29543002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB595;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.216.132.197;FPR:3FDF49D6.ACF68CEC.32F49570.45E0FAC9.202E0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, March 7, 2014 12:19 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Include the limit on the number
> of pfns we can handle
> 
> On Thu, Mar 06, 2014 at 11:15:08PM -0800, K. Y. Srinivasan wrote:
> > Increase the maximum number of pfns we can handle is a single vmbus
> packet.
> 
> Is that a correct sentance?
I will fix the typo in the sentence.
> 
> 
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  include/linux/hyperv.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h index
> > 330ec44..ab7359f 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -37,7 +37,7 @@
> >  #include <linux/mod_devicetable.h>
> >
> >
> > -#define MAX_PAGE_BUFFER_COUNT				19
> > +#define MAX_PAGE_BUFFER_COUNT				32
> 
> What is the problem if this number isn't changed?
On the networking side we may send frames that require more than 19 PFN entries.
Number 32 is imposed by some limitations by the vmbus data structures. For some reason
MAX_PAGE_BUFFER_COUNT was set to a lower value and I want to bump this up to what vmbus
can support.
> 
> Again, I'm going to have to ask you, what kernel is this for?
> 
> Please remember this when sending patches that look like they might be
> fixing a bug, you don't want me to guess, as my "guess" usually is "delete the
> patch".

Sorry Greg; this is not a bug fix and can go into the *next kernel.
I will resend this patch after fixing the changelog comment.

Regards,

K. Y 
> 
> greg k-h
