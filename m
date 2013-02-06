Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab3BFW7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:59:39 -0500
Received: from [1.9.68.9] ([1.9.68.9]:59309 "HELO mysmtp1.stec-inc.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1758101Ab3BFW7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:59:33 -0500
X-ASG-Debug-ID: 1360191569-053ea90dcf236d30001-xx1T2L
X-Barracuda-Envelope-From: akale@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Amit Kale <akale@stec-inc.com>
X-Barracuda-BWL-IP: fe80::64e7:ed5b:e6f9:c391
X-Barracuda-Apparent-Source-IP: fe80::64e7:ed5b:e6f9:c391
To: Michel Lespinasse <walken@google.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC: linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>,
        "thornber@redhat.com" <thornber@redhat.com>
Date: Thu, 7 Feb 2013 06:57:40 +0800
Subject: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Topic: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
X-ASG-Orig-Subj: RE: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
 caching software for Linux kernel
Thread-Index: Ac4A4DGwAIH/R3/VSoOa3I04Sa+EIQDvPXRA
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D66FE@MYMBX.MY.STEC-INC.AD>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
In-Reply-To: <CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1360191569
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.122015
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michel Lespinasse [mailto:walken@google.com]
> Sent: Friday, February 01, 2013 4:58 PM
> To: Darrick J. Wong
> Cc: Amit Kale; linux-bcache; device-mapper development; Kent
> Overstreet; Mike Snitzer; LKML; Jason Warr; thornber@redhat.com
> Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD
> caching software for Linux kernel
> 
> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > This is a patch to migrate STEC's enhanceio driver out of their
> github
> > repository and into the staging tree.  From their README:
> >
> > "EnhanceIO driver is based on EnhanceIO SSD caching software product
> > developed by STEC Inc. EnhanceIO was derived from Facebook's open
> > source Flashcache project. EnhanceIO uses SSDs as cache devices for
> > traditional rotating hard disk drives (referred to as source volumes
> throughout this document).
> > EnhanceIO can work with any block device, be it an entire physical
> > disk, an individual disk partition,  a RAIDed DAS device, a SAN
> > volume, a device mapper volume or a software RAID (md) device."
> 
> What's your take on the benefits of this vs bcache ?

EnhanceIO was designed for and has been validated in enterprise environments. The important benefits are - 
1. There is no downtime for cache creation, deletion, editing properties, writeback/readonly/writethrough mode change.
2. Wb mode comes with an option to control whether dirty data should be clean-up across reboots, which prevents SSD/HDD going out of sync.
3. Our in-house testing was done for large setups with 500GB+SSDs and proportionately large HDDs, on 24CPU machines with plenty of RAM. It's survived heavy IO loads without any locking or corruption problems.
4. Error handling is exactly what enterprises look for - writethrough/readonly modes work seamlessly regardless of SSD failures. In all the three caching modes, the guarantees of completion in presence of IO errors or shutdowns, in terms of granularity and persistence of data written, is identical to underlying HDDs.
5. It works for all known block devices - Software RAIDs, full block devices with or without partitions, individual partitions, various intelligent block devices.

-Amit

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
