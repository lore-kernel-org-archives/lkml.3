Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbaLWOo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:44:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45229 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaLWOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:44:27 -0500
Date: Tue, 23 Dec 2014 09:44:13 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH 05/17] btrfs: remove bio splitting and
 merge_bvec_fn() calls
To: Dongsu Park <dongsu.park@profitbricks.com>
CC: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Message-ID: <1419345853.13012.10@mail.thefacebook.com>
In-Reply-To: <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profit
	bricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
	<e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-23_05:2014-12-23,2014-12-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=29 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412230148
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 6:48 AM, Dongsu Park 
<dongsu.park@profitbricks.com> wrote:
> From: Kent Overstreet <kmo@daterainc.com>
> 
> Btrfs has been doing bio splitting from btrfs_map_bio(), by checking
> device limits as well as calling ->merge_bvec_fn() etc. That is not
> necessary any more, because generic_make_request() is now able to
> handle arbitrarily sized bios. So clean up unnecessary code paths.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> [dpark: add more description in commit message]
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> ---

Looks good, I'll test it here too.  Thanks!

Signed-off-by: Chris Mason <clm@fb.com>



