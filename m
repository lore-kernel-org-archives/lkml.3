Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab3E3WcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 18:32:20 -0400
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:48328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140Ab3E3WcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 18:32:13 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Russ Anderson <rja@sgi.com>
CC: joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        Matt Fleming <matt@console-pimps.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Topic: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Thread-Index: AQHOXYWFcUqvqo+O5EOQ++qV+11m6g==
Date: Thu, 30 May 2013 22:32:09 +0000
Message-ID: <1369953129.11620.15.camel@x230>
References: <20130523115801.GJ14575@console-pimps.org>
	 <20130523203234.GD20913@sgi.com> <20130524074331.GL14575@console-pimps.org>
	 <20130529210115.GC28027@sgi.com>
	 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	 <1369880172.17397.11.camel@linux-s257.site>
	 <20130530221737.GA11105@sgi.com> <1369952512.11620.14.camel@x230>
	 <20130530222836.GB11105@sgi.com>
In-Reply-To: <20130530222836.GB11105@sgi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-antispam-report: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <19611AE13F041C49A746B8C0303F99BF@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4UMWNnQ020993

On Thu, 2013-05-30 at 17:28 -0500, Russ Anderson wrote:
> On Thu, May 30, 2013 at 10:21:53PM +0000, Matthew Garrett wrote:
> > On Thu, 2013-05-30 at 17:17 -0500, Russ Anderson wrote:
> > 
> > > That's a great idea.  This patch moves the QueryVariableInfo()
> > > call from bootime to runtime, in efi_late_init().  The attached
> > > patch is consistent with the UEFI spec and avoids the problem.
> > 
> > No, that defeats the entire point of the original patch.
> 
> How so?  It is still calling QueryVariableInfo()
> before the data is used.

We want to know how much space is used by variables that aren't visible
at runtime.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
