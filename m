Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaHENrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:47:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23392 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751933AbaHENrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:47:17 -0400
Message-ID: <53E0E057.1060007@fb.com>
Date: Tue, 5 Aug 2014 09:47:03 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs extents related oops.
References: <20140805012845.GA7836@redhat.com> <20140805015758.GA9831@redhat.com>
In-Reply-To: <20140805015758.GA9831@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-05_05:2014-08-05,2014-08-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.34687855868343e-08 kscore.compositescore=0
 circleOfTrustscore=112.429318596174 compositescore=0.998981209195878
 urlsuspect_oldscore=0.998981209195878 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408050176
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 09:57 PM, Dave Jones wrote:
> On Mon, Aug 04, 2014 at 09:28:45PM -0400, Dave Jones wrote:
>  > Possibly related to some changes I've been making to my fuzz tester today
>  > to operate on the same file from multiple threads.
>  > This was on v3.16-829-g98959948a7ba, but probably exists on earlier trees too
>  > given the lack of btrfs specific commits so far this merge window.
> 
> reproducer:
> 
> trinity -q -l off -c lseek -c write
> 
> (Things also go very, very bad if you then try to umount that
>  partition - endless oopses, too mangled to parse).

So we're fuzzing lseek and btrfs goes crazy?  Looking.

-chris

