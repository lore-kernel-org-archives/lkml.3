Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbbANBMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:12:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57063 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbbANBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:12:19 -0500
Date: Tue, 13 Jan 2015 20:12:04 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: avoid build warning on 32-bit
To: <dsterba@suse.cz>
CC: Arnd Bergmann <arnd@arndb.de>, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <1421197924.21014.17@mail.thefacebook.com>
In-Reply-To: <20150114001606.GQ3685@twin.jikos.cz>
References: <4264141.3m7C7LgF5c@wuerfel>
	<20150114001606.GQ3685@twin.jikos.cz>
X-Mailer: geary/0.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_08:2015-01-13,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=9.37989809563335
 compositescore=0.929021023009889 urlsuspect_oldscore=0.929021023009889
 suspectscore=3 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.929021023009889 spamscore=0
 recipient_to_sender_domain_totalscore=76 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501140012
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 7:16 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Jan 13, 2015 at 03:09:03PM +0100, Arnd Bergmann wrote:
>>  A recent change introduced a type cast from a private 64-bit
>>  value to a pointer, which works fine on 64-bit architectures,
>>  but not on 32-bit ones, where it produces a harmless compiler
>>  warning:
>> 
>>  fs/btrfs/extent_io.c: In function 'btrfs_free_io_failure_record':
>>  fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer 
>> of different size [-Wint-to-pointer-cast]
>> 
>>  This adds an intermediate cast to 'unsigned long', which tells
>>  the compiler to ignore the type mismatch.
>> 
>>  Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>  Fixes: f612496bca664 ("Btrfs: cleanup the read failure record after 
>> write
>>  			or when the inode is freeing")
> 
> Already reported, but not merged

I'll take the original cast one for now and we can do the larger 
cleanup for the next merge window.

-chris

