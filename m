Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbaGQOMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:12:31 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:25829 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:12:29 -0400
Message-ID: <53C7D9CA.20405@imgtec.com>
Date: Thu, 17 Jul 2014 15:12:26 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <dborkman@redhat.com>, <ralf@linux-mips.org>
Subject: Re: [PATCH 2/3] arch/mips/net/bpf_jit.c: fix failure check
References: <1405603655-12571-1-git-send-email-andrey.krieger.utkin@gmail.com>	<53C7D52E.5020205@imgtec.com> <CANZNk81DOOxYYFSKZMCh=uABd3ONB8wToTFc3_L_9TfyQDS1yQ@mail.gmail.com>
In-Reply-To: <CANZNk81DOOxYYFSKZMCh=uABd3ONB8wToTFc3_L_9TfyQDS1yQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 02:58 PM, Andrey Utkin wrote:
> 2014-07-17 16:52 GMT+03:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>> Thanks for the patch. I would personally prefer to use a new signed int
>> variable, but I am fine either way.
> 
> If that's not a problem for performance etc., then i'll resubmit with
> new temporary signed variable, because i believe it would be simpler
> to comprehend.
> 
Hi Andrey,

Well, this function is executed during the filter compilation so it's
only executed once (or maybe a few times) per filter (assuming the
filter uses the SKF_AD_PKTTYPE opcode at all) so performance is not
really critical at this point. The performance become a critical factor
for the execution of the jitted filter. But yes, avoiding passing the
argument and doing the pointer operation later on could save some
instructions which is both good for compilation performance and also
makes the function simpler as you said.

-- 
markos
