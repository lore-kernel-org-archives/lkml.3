Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3KQVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:09:18 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59123 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3KQVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:09:10 -0500
MIME-Version: 1.0
In-Reply-To: <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	<1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
Date: Sun, 17 Nov 2013 19:09:07 -0200
Message-ID: <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor code
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
>> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' and
>> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' when
>> necessary.
>
> You pointlessly renamed a variable, which makes the diff hard to read.
> Please don't do that.

Ok, I can agree. 'len' means length? What is returned in case of non error?

>
> You missed the fact that the passed in pointer is unmodified if
> mgmt_get_if_info() returns non zero, so the kfree frees junk and would
> oops.
>
> There's no need for a goto; len = -EINVAL; does everything that's
> needed.

Well, that is a coverity catch. CID 1128954. Check it.

>
> James
>
>

Thanks.


-- 
Regards,

Geyslan G. Bem
hackingbits.com
