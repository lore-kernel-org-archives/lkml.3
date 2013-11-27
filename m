Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3K0Ovw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:51:52 -0500
Received: from usindpps04.hds.com ([207.126.252.17]:42236 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3K0Ovq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:51:46 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matt Fleming <matt@console-pimps.org>, Madper Xie <cxie@redhat.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "richard@nod.at" <richard@nod.at>, Tony Luck <tony.luck@gmail.com>
Subject: RE: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Thread-Topic: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Thread-Index: AQHO6EL0bqha0XG3uEyApP3rF7R0t5o5T2gA///fIhA=
Date: Wed, 27 Nov 2013 14:51:22 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D47FA16730@USINDEM103.corp.hds.com>
References: <87bo1bnxhi.fsf@redhat.com>
 <20131127114440.GF18170@console-pimps.org>
In-Reply-To: <20131127114440.GF18170@console-pimps.org>
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
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-11-27_04:2013-11-27,2013-11-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311270073
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Wednesday, November 27, 2013 6:45 AM
> To: Madper Xie
> Cc: 'linux-kernel@vger.kernel.org'; linux-efi@vger.kernel.org; matt.fleming@intel.com; Seiji Aguchi; richard@nod.at; Tony Luck
> Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
> 
> On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
> >
> > Pstore fs expects that backends provide a uniqued id which could avoid
> > pstore making entries as duplication or denominating entries the same
> > name. So I combine the timestamp, part and count into id.
> >
> > Signed-off-by: Madper Xie <cxie@redhat.com>
> > ---
> >  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> Thanks unless anyone complains, I'm going to apply this.
> 

I'm OK with this patch based on Madper's comment below.

<snip>
So i'd like to using fixed length. My dell xps has 128kb nvram
space. and it at most store 126 pstore entries. So I think 1000 will be
a safe value for count. For part, 100 should be okay. I don't think
there will be a large kmsg and we must split it into more than 100 parts.
<snip>

> Does this need to be tagged for stable?
> 

I think so.

Seiji

> --
> Matt Fleming, Intel Open Source Technology Center
