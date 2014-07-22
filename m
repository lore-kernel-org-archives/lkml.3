Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaGVL0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:26:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbaGVL0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:26:09 -0400
Message-ID: <53CE4A41.4020605@zytor.com>
Date: Tue, 22 Jul 2014 04:25:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Klemen Jan Enova <klemen.jan.enova@gmail.com>,
        linux-kernel@vger.kernel.org
CC: mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH] arch: x86: boot: bioscall.S: simplify self-modification
 of the INT instruction
References: <53CE449C.2090001@gmail.com>
In-Reply-To: <53CE449C.2090001@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 04:01 AM, Klemen Jan Enova wrote:
> At the start of the intcall function, the %al register is compared to
> 0x3f. If it does not equal 0x3f it is equated to it. Instruction flow
> continues in both cases from the label 1. The comparison is therefore
> unneeded.
> 
> Testing data is appended.
> 
> Signed-off-and-tested-by: Klemen Jan Enova <klemen.jan.enova@gmail.com>

NAK.

This is a performance optimization - the SMC takes a substantial penalty
so the write is avoided if necessary.

Also, 3f is a label, not 0x3f.

	-hpa

