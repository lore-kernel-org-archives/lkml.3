Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3DOQmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:42:21 -0400
Received: from masquerade.micron.com ([137.201.242.130]:27275 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3DOQmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:42:20 -0400
From: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
Subject: RE: [PATCH 2/2] mtip32xx: mtip32xx: Disable TRIM support
Thread-Topic: [PATCH 2/2] mtip32xx: mtip32xx: Disable TRIM support
Thread-Index: AQHON6t6ZnWtbpW5xE+1YspwbazwopjVyHQAgAG02zA=
Date: Mon, 15 Apr 2013 16:41:42 +0000
Message-ID: <80B89753B40C5141A3E2D53FE7A2A8A93016D03A@NTXBOIMBX02.micron.com>
References: <51685232.2040209@micron.com> <20130414082522.GE12244@kernel.dk>
In-Reply-To: <20130414082522.GE12244@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-19798.007
x-tm-as-result: No--40.435000-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, Apr 12 2013, Asai Thambi S P wrote:
> >
> > Temporarily disabling TRIM support until TRIM related issues
> > are addressed in the firmware.
> 
> How serious is this? We do have released kernels out there with the
> driver, you might want to consider a stable backport too.

It's a performance issue, not data integrity.  Since the ATA trim command
is non-queueable, IO traffic must halt while the trim is outstanding.  A 
filesystem that is actively trimming sectors is effectively duty cycling 
the IO path on this part.  We are working to shrink the trim command 
latency while also investigating whether some sort of offline trim is more
appropriate.

Given the incremental endurance gain for trim on 34nm SLC vs the severe 
throughput degradation under some workloads, it seemed prudent to disable
the feature.

If you think that warrants a stable backport, just let me or Asai know.

-Sam


