Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbbAHOwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:52:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:32917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbbAHOw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:52:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="509326745"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>
Subject: RE: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Topic: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Thread-Index: AQHQI41CoFze/rj2YEaQrKcsZxtS4pyyOcYAgABmfYCAAr8x0IAAS5qAgACxhlA=
Date: Thu, 8 Jan 2015 14:52:24 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7326E29B2@PGSMSX105.gar.corp.intel.com>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
 <20150106073634.GB59754@vmdeb7> <54ABE67B.1070706@nexus-software.ie>
 <AF233D1473C1364ABD51D28909A1B1B7326E0C25@PGSMSX105.gar.corp.intel.com>
 <54AE73C7.90009@nexus-software.ie>
In-Reply-To: <54AE73C7.90009@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On 07/01/15 23:45, Ong, Boon Leong wrote:
>>> Since BIOS and grub code both use 0x00000000 as the 'off' address I
>>> think it makes sense for the kernel to continue to use that address.
>>
>> Just add on top of what Daren mentioned in another mail, based on the
>> Quark document, the base address can start from zero. Say lo=0, hi=0,
>> and WM & RM may be changed from default value, 1st 1KiB will be marked as
>IMR. It seems to me that there is no good way to test if an IMR is 'occupied'
>and/or 'enabled'
>> since enable-bit is not available. But, what is benefit of testing
>> against lo=0 & hi=0? The logic to calculate size will work under
>> lo=0 & hi=0 anway.
>
>Hi Boon Leong.
>
>I think it does make sense to add a check for rmask and wmask in the 'access all'
>state when determining if an IMR is enabled on X1000 or not

Ya, checking against rmask & wmask whether they have been changed from default stage
would help here. Thanks 
