Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaCaG4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 02:56:40 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:41531 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaCaG4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 02:56:39 -0400
Date: Mon, 31 Mar 2014 08:56:37 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: artagnon@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        hskinnemoen@gmail.com
Subject: Re: [PATCH] avr32: replace simple_strtoul() with kstrtoul()
Message-ID: <20140331065637.GA21509@samfundet.no>
References: <CACVxJT_vYPeQqvDHT-TELb+EzcaE+YzTLnSUkBLVf_vm_zGCng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT_vYPeQqvDHT-TELb+EzcaE+YzTLnSUkBLVf_vm_zGCng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 19 Mar 2014 12:52:35 +0300 or thereabout, Alexey Dobriyan wrote:
>> - val = simple_strtoul(buf, &endp, 0);
>> - if (endp == buf || val > 0x3f)
>> - return -EINVAL;
>> + ret = kstrtoul(buf, 0, &val);
>> + if (ret)
>> + return ret;
>>   val = (val << 12) | (sysreg_read(PCCR) & 0xfffc0fff);
> 
> you removed 0x3f check
> 
> this conversion is not trivial as it seems

Is anybody going to update this patch? I planned to push early this round, as
others are waiting for AVR32 changes.

-- 
Best regards,
Hans-Christian Egtvedt
