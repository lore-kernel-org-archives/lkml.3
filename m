Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaHSO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:58:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63047 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbaHSO6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:58:16 -0400
Message-ID: <53F36601.5020609@fb.com>
Date: Tue, 19 Aug 2014 10:58:09 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <dsterba@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Abhay Sachan <lkp.abhay@gmail.com>
Subject: Re: [btrfs] 8d875f95: xfstests.generic.226.fail
References: <20140816075233.GA26842@localhost> <20140819115820.GA21418@localhost> <20140819142348.GU1553@twin.jikos.cz>
In-Reply-To: <20140819142348.GU1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-19_03:2014-08-19,2014-08-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.16333634234434e-15 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408190174
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 10:23 AM, David Sterba wrote:
> On Tue, Aug 19, 2014 at 07:58:20PM +0800, Fengguang Wu wrote:
>> We noticed an xfstests failure on commit
>>
>> 8d875f95da43c6a8f18f77869f2ef26e9594fecc ("btrfs: disable strict file flushes for renames and truncates")
>>
>> It's 100% reproducible in the 5 test runs.
> 
> Same here, different mkfs configurations.
> 
> generic/226 28s ...    [16:11:52] [16:12:55] - output mismatch (see /root/xfstests/results//generic/226.out.bad)
>     --- tests/generic/226.out   2013-05-29 17:16:03.000000000 +0200
>     +++ /root/xfstests/results//generic/226.out.bad     2014-08-19 16:12:55.000000000 +0200
>     @@ -1,6 +1,8 @@
>      QA output created by 226
>      --> mkfs 256m filesystem
>      --> 16 buffered 64m writes in a loop
>     -1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
>     +1 2 3 4 pwrite64: No space left on device
>     +5 6 7 8 9 10 11 12 pwrite64: No space left on device
>     +13 14 15 16
> 
> enospc on a small filesystem (256M)

I'm calling filemap flush more often, but otherwise everything else is
the same.  I'll take a look.

-chris
