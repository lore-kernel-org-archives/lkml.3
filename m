Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3BRLm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:42:28 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37727 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3BRLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:42:27 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
	<87fw0t3mq0.fsf@devron.myhome.or.jp>
Date: Mon, 18 Feb 2013 20:42:24 +0900
In-Reply-To: <87fw0t3mq0.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Mon, 18 Feb 2013 20:06:31 +0900")
Message-ID: <877gm526hr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

>> +	if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>> +		*lenp = FAT_FID_SIZE_WITH_PARENT;
>> +		return 255;
>> +	} else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>> +		*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>> +		return 255;

We would be better to use FILEID_INVALID on all places, instead of 255.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
