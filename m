Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaKCBVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 20:21:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51272 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbaKCBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 20:21:12 -0500
Message-ID: <5456D867.5020303@fb.com>
Date: Sun, 2 Nov 2014 18:20:39 -0700
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <hch@infradead.org>, <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <5456A787.5060104@free-electrons.com> <5456AE72.1010409@nod.at> <5456AFEA.6000507@free-electrons.com> <5456B4F8.1000608@nod.at>
In-Reply-To: <5456B4F8.1000608@nod.at>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-03_01:2014-10-31,2014-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.12498974524102 urlsuspect_oldscore=0.12498974524102
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.12498974524102 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411030012
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-02 15:49, Richard Weinberger wrote:
> AFAICT blk-mq allocates one struct ubiblock_pdu per device.
> As all IO is done via scattergather the memory footprint should be good.
> But I'm sure Christoph can tell you the glory details.

That is true, the request list and pdu is allocated upfront. If that is 
a problem, the pdu need not be allocated upfront but could be done at IO 
time instead. With that comes a bit more complicated retry handling, for 
memory shortage situations.

-- 
Jens Axboe

