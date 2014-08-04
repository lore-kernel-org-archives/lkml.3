Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaHDN3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:29:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20365 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117AbaHDN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:29:49 -0400
Message-ID: <53DF8AC8.3010708@fb.com>
Date: Mon, 4 Aug 2014 09:29:44 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE" 
	<linux-btrfs@vger.kernel.org>
Subject: Re: Work Queue for btrfs compression writes
References: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
In-Reply-To: <CAPDOMVjJHbCwDVyKQ+Vuse7G76FLSLq69Ja4kmopDbjtEb_Zkw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-04_01:2014-08-04,2014-08-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.11910480882216e-13 kscore.compositescore=0
 circleOfTrustscore=1749.24041094204 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408040161
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 11:54 PM, Nick Krause wrote:
> Hey Guys ,
> I am new to   reading  and writing  kernel code.I got interested in
> writing code for btrfs as it seems to
> need more work then other file systems and this seems other then
> drivers, a good use of time on my part.
> I interested in helping improving the compression of btrfs by using  a
> set of threads using work queues like XFS
> or reads and keeping the page cache after reading compressed blocks as
> these seem to be a great way to improve
> on  compression performance mostly with large partitions of compressed
> data. I am not asking you to write the code
> for me but as I am new a little guidance and help would be greatly
> appreciated as this seems like too much work for just a newbie.

[ Back from vacation ]

Reading through the thread, I don't see anyone mentioning that btrfs
already funnels most compression through helper threads in the kernel
workqueues.

There is also an ordering component that submits the compressed bios to
disk (for writes) in the same order they were created.  This lets us
scatter compression across N cpus, but not introduce seeks if they make
progress at different rates.

-chris

