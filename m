Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaKLSCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:02:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8458 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbaKLSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:02:30 -0500
Date: Wed, 12 Nov 2014 12:59:33 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't check for file->private_data on open(). It
 is set by the core.
To: Martin Kepplinger <martink@posteo.de>
CC: <linux-btrfs@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Martin Kepplinger <martink@posteo.de>
Message-ID: <1415815173.25389.2@mail.thefacebook.com>
In-Reply-To: <1415810308-24243-1-git-send-email-martink@posteo.de>
References: <1415810308-24243-1-git-send-email-martink@posteo.de>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-12_08:2014-11-11,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411120138
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:38 AM, Martin Kepplinger <martink@posteo.de> 
wrote:
> The miscdevice core now sets file->private_data to the struct 
> miscdevice
> so don't fail when this is not NULL.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is a question: what does this check provide and does overwriting
> file->private_data make any difference?
> 
> Is miscdevice's open() by the user not allowed here, if 
> file->private_data
> is set?
> 
> thanks!!

Btrfs uses this in the transaction start ioctl to record the 
transaction handle being started.  Ceph is the main user of the ioctl, 
and we could setup a hash table if needed.  But which call path in 
miscdevice is doing this?

With your patch in place, btrfs would end up overwriting the miscdevice 
private_data field, which would probably cause problems.

-chris

