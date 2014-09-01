Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIANyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:54:40 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37404 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIANyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:54:38 -0400
Message-ID: <54047A96.1090900@codethink.co.uk>
Date: Mon, 01 Sep 2014 14:54:30 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
References: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com>
In-Reply-To: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't agree. Ultimately this parameter ends up as a parameter to
kmalloc where it is expected to be a size_t.

On 01/09/14 14:43, Alexey Dobriyan wrote:
>>   void *__seq_open_private(struct file *f, const struct seq_operations *ops,
>> - int psize)
>> + size_t psize)
>
> It should be "unsigned int" at most.
> As almost all in-kernel lengths.
>
>      Alexey
>
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
