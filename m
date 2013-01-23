Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3AWApM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:45:12 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:35581 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3AWApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:45:08 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Huang Ying <ying.huang@intel.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "robert.moore@intel.com" <robert.moore@intel.com>,
        "trenn@suse.de" <trenn@suse.de>,
        "myron.stowe@redhat.com" <myron.stowe@redhat.com>
Subject: RE: ERST: how to avoid a dynamic memory allocation in panic case
Thread-Topic: ERST: how to avoid a dynamic memory allocation in panic case
Thread-Index: Ac349nJDZpYrCzzbTuW1wPMkV8nEDQANZ/EAAApZ4ZA=
Date: Wed, 23 Jan 2013 00:44:19 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A520D4@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A51F3D@USINDEM103.corp.hds.com>
 <1358901594.7408.85.camel@yhuang-dev>
In-Reply-To: <1358901594.7408.85.camel@yhuang-dev>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-22_10:2013-01-22,2013-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301220265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0N0jBh0032661



> > <snip>
> > @@ -918,10 +918,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
> >  	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> >  	if (!virt_addr) {
> >  		rcu_read_unlock();
> > -		virt_addr = acpi_os_ioremap(phys_addr, size);
> > -		if (!virt_addr)
> > -			return AE_BAD_ADDRESS;
> > -		unmap = true;
> > +		return AE_BAD_ADDRESS;
> 
> No.  We can not do that.  Because some users rely on acpi_os_read_memory to do ioremap for them.

Thank you for giving me the information.

> The correct fixing should be pre-map the io-memory that may be accessed in erst code patch with acpi_map().

I will take a look at the code.

Seiji
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
