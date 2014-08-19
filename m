Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaHSHc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:32:56 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:13364 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbaHSHcz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:32:55 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2014 15:22:43 +0800
Subject: CONFIG_ENABLE_VMALLOC_SAVING  problem
Thread-Topic: CONFIG_ENABLE_VMALLOC_SAVING  problem
Thread-Index: Ac+7fjS3hzBxE1yEStuuXcMAOIdUnAAABydQ
Message-ID: <35FD53F367049845BC99AC72306C23D103B42F948AAD@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103B42F948AAC@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103B42F948AAC@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi 

I found when I enable CONFIG_ENABLE_VMALLOC_SAVING on ARM arch,
Vmalloc still only use VMALLOC_START --  VMALLOC_END virtual address,
It don't use the memory hole address,
Only  function call  get_vm_area_caller  like ioremap can use
These memory hole address .

Why not change vmalloc also use this address?

Another problem is that when I cat /proc/meminfo ,
The VmallocTotal item  show  doesn't include memory hole address,
It only show VMALLOC_START --  VMALLOC_END  ,
I think it is not correct here , should add memory hole as vmalloc when 
CONFIG_ENABLE_VMALLOC_SAVING  is enabled , isn't it ?


Thanks


