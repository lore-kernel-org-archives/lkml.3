Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3FXLBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:01:20 -0400
Received: from mail.arrisi.com ([216.234.147.109]:36377 "EHLO mail.arrisi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3FXLBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:01:17 -0400
X-Greylist: delayed 1364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 07:01:17 EDT
From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
To: Namjae Jeon <linkinjeon@gmail.com>
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <esandeen@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "a.sangwan@samsung.com" <a.sangwan@samsung.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Thread-Topic: [PATCH 0/3] ext4: introduce two new ioctls
Thread-Index: AQHOb9f7HUFqNhg8uk2pYvwWXeM+/g==
Date: Mon, 24 Jun 2013 10:37:57 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CDB7@ATLEXMBX4.ARRS.ARRISI.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard> <20130624070656.GA20166@infradead.org>
 <CAKYAXd-hJ71+zDn5c2ABb2J-zL=kb2M=GNzOWNHkS7-C4KXEzA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [216.234.147.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-24_01:2013-06-24,2013-06-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.0947299728168617 urlsuspect_oldscore=0.944009186409651
 suspectscore=0 recipient_domain_to_sender_totalscore=290 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=33046
 rbsscore=0.0947299728168617 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1306240056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.2013 13:36, Namjae Jeon wrote:
> Currently, we can try implementing dave's suggesstion of introducing a
> new flag FALLOC_FL_COLLAPSE_RANGE for falloctae instead of individual
> ioctls for both XFS and EXT4. Thanks.

Hi,

Currently PUNCH_HOLE requires KEEP_SIZE to be set as well. I think there
is no need to invent COLLAPSE_RANGE, but instead fallocate should
support PUNCH_HOLE without KEEP_SIZE. However I'm not sure that putting
block alignment restriction is a right way to go.

Regards,
Andrey.
