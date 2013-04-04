Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3DDBRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:17:36 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52516 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762885Ab3DDBRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:17:34 -0400
Message-ID: <515CD4A7.6070903@gmail.com>
Date: Thu, 04 Apr 2013 09:17:27 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com> <515CD359.40004@gmail.com> <515CD3BF.5010104@zytor.com>
In-Reply-To: <515CD3BF.5010104@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H.Peter,
On 04/04/2013 09:13 AM, H. Peter Anvin wrote:
> On 04/03/2013 06:11 PM, Simon Jeons wrote:
>> Why we consider boot_cpu_data.x86_phys_bits instead of e820 map here?
>>
> Because x86_phys_bits is what controls how much address space the
> processor has.  e820 tells us how much *RAM* the machine has, or
> specifically, how much RAM the machine had on boot.

e820 also contain mmio, correct? So cpu should not access address beyond 
e820 map(RAM+MMIO).

>
> 	-hpa
>

