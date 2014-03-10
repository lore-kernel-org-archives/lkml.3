Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaCJTLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:11:47 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:53485 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaCJTLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:11:44 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: RE: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Topic: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Index: AQHPDlBjPwJavIH01UGK8YIeAgS3uJrRWfSAgAmwuGA=
Date: Mon, 10 Mar 2014 19:10:17 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A066E08AFE@G4W3212.americas.hpqcorp.net>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
 <20140304150611.GE2799@8bytes.org>
In-Reply-To: <20140304150611.GE2799@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.21]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tue 3/4/2014 9:06 AM, Joerg Roedel wrote:
>
>On Fri, Jan 10, 2014 at 03:07:26PM -0700, Bill Sumner wrote:
>> Bill Sumner (6):
>>   Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
>>   Crashdump-Accepting-Active-IOMMU-Utility-functions
>>   Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
>>   Crashdump-Accepting-Active-IOMMU-Copy-Translations
>>   Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
>>   Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
>>
>>  drivers/iommu/intel-iommu.c | 1293
>> ++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 1225 insertions(+), 68 deletions(-)
>
>This is a pretty big change, before merging I would like to get more eyes on it. Please make sure you get more reviews on the code and the general concept. A few things I noticed while looking at it:
Yes, as I was developing this, I realized that it is far more code than most Linux submissions.  In addition to more eyes reviewing the code, I hope to see additional members of the community trying it out -- testing it on a wide variety of system configurations.  Let me encourage additional reviewers and testers to look at this fix to crashdump.
>
>* You put a lot of code into #define CONFIG_CRASH_DUMP. Isn't the same approach necessary to for KEXEC?
Until I saw your email, I had been focused only on the immediate problem of fixing crashdump and had not considered using this approach in the more-general context of KEXEC.  It certainly looks like it could be useful with KEXEC as well.  

I would like to take-on the effort of expanding this technique into KEXEC as a separate follow-on project so that the original "fix crashdump" project is not delayed.  On a quick look, I believe that the amount of additional code would be minimal; but the expansion of the testing matrix might be quite large.
>
>* Please get rid of all the pr_debug stuff.
Will do.
>
>* I think it makes sense to put the functions to access the IOMMU
>  configuration values of the old kernel into a new file. This is better
>  than adding over 1000 new lines to intel-iommu.c
Sounds good.  I will move these functions into a new file.
>
>* I have seen your new single-patch for this change. A single patch with
>  more than 1200 changed lines is not something anyone is willing to
>  review. Please split the patches again in a meaningful and bisectable
>  way.
I will return to a multiple-patch set for future submissions.


-- Bill
