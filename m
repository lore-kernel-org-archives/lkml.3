Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbaLHGEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:04:41 -0500
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:60864
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750776AbaLHGEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:04:39 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 3/3] Drivers: hv: hv_balloon: Don't post pressure status
 from interrupt context
Thread-Topic: [PATCH 3/3] Drivers: hv: hv_balloon: Don't post pressure status
 from interrupt context
Thread-Index: AQHQDnWxDB0xAh+t50GZ+NsrXE77nZyDy/QAgAFvs4A=
Date: Mon, 8 Dec 2014 06:04:35 +0000
Message-ID: <BY2PR0301MB07114733895C69D3CC61A90AA0640@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-3-git-send-email-kys@microsoft.com>
 <20141207080433.GA4531@sucs.org>
In-Reply-To: <20141207080433.GA4531@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;UriScan:;
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0711;
x-forefront-prvs: 041963B986
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(13464003)(189002)(51704005)(199003)(377454003)(15395725005)(87936001)(19580405001)(4396001)(20776003)(46102003)(64706001)(86612001)(31966008)(62966003)(33656002)(101416001)(77156002)(2656002)(74316001)(86362001)(54606007)(50986999)(76176999)(54356999)(54206007)(19580395003)(1411001)(21056001)(66066001)(92566001)(76576001)(107046002)(120916001)(106116001)(110136001)(97736003)(40100003)(122556002)(99396003)(106356001)(105586002)(99286002)(15975445007)(102836002)(68736005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0661;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Sunday, December 7, 2014 12:05 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 3/3] Drivers: hv: hv_balloon: Don't post pressure status
> from interrupt context
> 
> On Tue, Dec 02, 2014 at 02:29:15PM -0800, K. Y. Srinivasan wrote:
> > We currently release memory (balloon down) in the interrupt context
> > and we also post memory status while releasing memory. Rather than
> > posting the status in the interrupt context, wakeup the status posting
> thread to post the status.
> > This will address the inconsistent lock state that Sitsofe Wheeler
> > <sitsofe@gmail.com>
> > reported:
> 
> Sorry I didn't follow up on this. Things looked better after the patch but I was
> seeing a strange issue where the memory was being reduced to some
> minimum and the balloon would never shrink so the available memory was
> seemingly locked from then on. I ran out of time to investigate this later
> behaviour and didn't have the time to check if it had always been the case
> but I think I see other patches saying you nailed it and other issues. Do you
> have a published git tree with all these pieces in or have they already been
> mainlined?

Greg has not committed these patches yet. One of the patches changes the balloon floor.
This means that the guest will not be ballooned down below the floor. Is this what you are
seeing? In our testing we did not see anything unusual other than the floor being elevated
(as per the design).

K. Y 
> 
> --
> Sitsofe | http://sucs.org/~sits/
