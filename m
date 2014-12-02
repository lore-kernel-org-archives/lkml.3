Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaLBIoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:44:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:37970 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLBIoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:44:03 -0500
Message-ID: <547D7BC6.6070708@windriver.com>
Date: Tue, 2 Dec 2014 16:43:50 +0800
From: zhangxiao <xiao.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: <agk@redhat.com>, <snitzer@redhat.com>, <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, <linux-raid@vger.kernel.org>,
        <dm-devel@redhat.com>
Subject: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it flexible?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.163.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Experts,

See drivers/md/dm-bufio.c as below:
   50 /*
   51  * Buffer hash
   52  */
   53 #define DM_BUFIO_HASH_BITS      20
   54 #define DM_BUFIO_HASH(block) \
   55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
   56          ((1 << DM_BUFIO_HASH_BITS) - 1))
"drivers/md/dm-bufio.c" 1854L, 45375C

DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
use case with limited resources. Do we have any plan to make it more
flexible? Like module parameter or something else?

Thanks
Xiao
