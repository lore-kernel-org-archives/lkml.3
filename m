Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHRDzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:55:39 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:3393
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751716AbaHRDzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:55:37 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Thread-Topic: [PATCH] Input: hyperv-keyboard - implement Type Clipboard Text
Thread-Index: AQHPuKofLzaqUkka1EmYO6oSNGBw9pvVuwLg
Date: Mon, 18 Aug 2014 03:54:51 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9933040@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <1408095719-19117-1-git-send-email-decui@microsoft.com>
 <20140815165733.GB25225@core.coreip.homeip.net>
In-Reply-To: <20140815165733.GB25225@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(438002)(189002)(13464003)(51914003)(164054003)(199003)(377454003)(51704005)(6806004)(95666004)(44976005)(84676001)(81542001)(81342001)(69596002)(83322001)(68736004)(47776003)(20776003)(64706001)(85806002)(46406003)(81156004)(31966008)(26826002)(16796002)(21056001)(106116001)(110136001)(107046002)(106466001)(85306004)(92726001)(86362001)(97756001)(92566001)(77982001)(97736001)(79102001)(46102001)(87936001)(76482001)(85852003)(86612001)(2656002)(76176999)(55846006)(50986999)(83072002)(99396002)(54356999)(74502001)(80022001)(23726002)(4396001)(50466002)(33656002)(77096002)(74662001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB253;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dmitry Torokhov
> Sent: Saturday, August 16, 2014 0:58 AM
> To: Dexuan Cui
> > For each char in the string, the host sends 2 events (key down/up with the
> > char's UNICODE value) to the guest.
> > The patch finds each char's scan codes of key down/up, and injects the
> > scan codes to the serio keyboard module.
> >
> > Known issues:
> > 1) Only printable ASCII chars are supported, and unsupported chars are
> > ignored. It seems unlikely to support generic UNICODE chars because there
> > is not a generic API to inject a UNICODE char to text mode console, KDE,
> > gnome, etc.
> >
> > 2) When we use the feature, make sure the CapsLock state of the VM's
> > (virtual) keyboard is OFF because this patch assumes it -- we'll try to
> > fix this later, probably by tracking the state of virtual CapsLock, because
> > it looks the keyboard module doesn't supply an API for us to query the
> state
> > of the keyboard.
> >
> No way. If you want to do this this way, do it in hypervisor code and keep
> feeding AT scan codes to hyperv-keyboard, although I am pretty sure users
Hi Dmitry,
Yeah, I had the same wish, but later I found this seems unlikely because IMO
the feature was firstly invented for Windows VM + generic UNICODE chars,
and we know there is no "scan code" for generic UNICODE chars... :-(

> of
> French, Czech and other keyboard layouts with numbers in upper register
> and
> symbols in lower will have a few choice words for you.
Sorry, I can't understand what these are.
Can you please give more details or a link to further info?

> If you want real cut-and-paste support in various DEs I'd recommend
> working
> with VMware on open-vm-tools package to see what can be shared/reused
> there.
> Consider this NACked with prejudice.
> Dmitry
Thanks for the suggestion!
Let me study open-vm-tools and report back.

Thanks,
-- Dexuan
