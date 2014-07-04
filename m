Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaGDPf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 11:35:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30866 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbaGDPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 11:35:25 -0400
Message-ID: <53B6C9BA.1020106@fb.com>
Date: Fri, 4 Jul 2014 09:35:22 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch]blk-mq: suppress a warning
References: <20140704112623.GA17435@kernel.org>
In-Reply-To: <20140704112623.GA17435@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-04_05:2014-07-04,2014-07-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.61524268089175e-08 kscore.compositescore=0
 circleOfTrustscore=502.112 compositescore=0.9989857498195
 urlsuspect_oldscore=0.9989857498195 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407040177
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 05:26 AM, Shaohua Li wrote:
> 
> The warning is hit when cpu hotplug is running. After scheduler puts a cpu
> online and before blk-mq mapping reinit, a task can queue a request and run the
> queue. At that time the cpu isn't in hctx->cpumask, but the cpu is mapped into
> hctx 0. When the race happens, hctx->cpumask doesn't set the cpu and
> ctx->index_hw/hctx->nr_ctx isn't correct, but it doesn't cause any problem. So
> just suppress the warning here.

Thanks Shaohua, I think that is an improvement. Not super fond of having
to do an extra map, but it's saner than the CPU test in that it uses the
same mechanism to verify it's correct. And we can probably kill this
WARN_ON() in a revision or two.


