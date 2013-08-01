Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3HAT5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:57:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:16606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab3HAT5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,796,1367996400"; 
   d="scan'208";a="340309660"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Christoph Hellwig <hch@infradead.org>,
        Xiong Zhou <jencce.kernel@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Thread-Topic: [PATCH v2] staging/lustre: lloop depends on BLOCK
Thread-Index: AQHOjLwGfTLDngp0wkGXFdutzRRQL5mAgt+AgABXF4A=
Date: Thu, 1 Aug 2013 19:57:22 +0000
Message-ID: <CE20190F.5958F%andreas.dilger@intel.com>
In-Reply-To: <20130801084539.GA13306@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.123.219]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0C5FFF7E63AA0842ADDEDA7225C7A1E5@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/08/01 2:45 AM, "Christoph Hellwig" <hch@infradead.org> wrote:

>On Tue, Jul 30, 2013 at 08:29:51AM +0800, Xiong Zhou wrote:
>> From: Xiong Zhou <jencce.kernel@gmail.com>
>> 
>> In the lustre client driver, lloop depends on BLOCK. Add an
>> option for this dependence. Last version of this patch makes
>> LUSTRE_FS depends on BLOCK.
>> Remove unnecessary jdb head files which depends on BLOCK.
>
>The driver should be removed, a filesystem has no business bringing
>its own loop driver.

It provides significant performance improvement for network IO on Lustre.
It bypasses DLM locking in Lustre and the VFS layer on the client, copying
in the loop driver, and page-by-page IO submission in the normal IO path.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


