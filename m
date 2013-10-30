Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3J3TTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:19:50 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:50447 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3J3TTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:19:48 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: RE: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs entry
 until, the scan is completed
Thread-Topic: [PATCH v3] efivars,efi-pstore: Hold off deletion of sysfs
 entry until, the scan is completed
Thread-Index: AQHOxq/e4sZK5DM4RE6BnyVI+JE7Npn5LGGAgAHpKMCAEpqygIAADAng
Date: Wed, 30 Oct 2013 19:19:11 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D3F39@USINDEM103.corp.hds.com>
References: <52584373.3010202@hds.com>
 <20131017131821.GH10834@console-pimps.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443F0F2D6@USINDEM103.corp.hds.com>
 <20131030143527.GB8193@console-pimps.org>
In-Reply-To: <20131030143527.GB8193@console-pimps.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-30_06:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 18 Oct, at 10:30:58PM, Seiji Aguchi wrote:
> > The scanning and deleting logic is still needed.  In case an entry(A)
> > is found, the pointer is saved to psi->data.  And efi_pstore_read()
> > passes the entry(A) to a pstore filesystem by releasing
> > __efivars->lock.
> >
> > And then, the pstore filesystem calls efi_pstore_read() again and the
> > same entry(A), which is saved to psi->data, is used for re-scanning a
> > sysfs-list.  (That is why list_for_each_entry_safe_from () is used in
> > efi_pstore_sysfs_entry_iter().)
> >
> > So, to protect the entry(A), the logic is needed because, in pstore
> > filesystem,  __efivars->lock Is released.
> 
> Very good point.

Thanks,

I will add the description in the next patch.

Seiji
