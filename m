Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbbA2L3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:29:39 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:51908 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbbA2L3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:29:36 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, behanw@converseincode.com,
        sathya.perla@emulex.com, ajit.khaparde@emulex.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        subbu.seetharaman@emulex.com
Subject: Re: [PATCH] net, ethernet, LLVMLinux: Add missing MODULE_DEVICE_TABLE()
References: <1422495374-22835-1-git-send-email-behanw@converseincode.com>
	<20150128.224228.1533046356464752424.davem@davemloft.net>
	<3392784.h8cmHX9fyr@wuerfel>
Date: Thu, 29 Jan 2015 11:29:32 +0000
In-Reply-To: <3392784.h8cmHX9fyr@wuerfel> (Arnd Bergmann's message of "Thu, 29
	Jan 2015 10:10:48 +0100")
Message-ID: <yw1xlhklbzab.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday 28 January 2015 22:42:28 David Miller wrote:
>> From: Behan Webster <behanw@converseincode.com>
>> Date: Wed, 28 Jan 2015 17:36:14 -0800
>> 
>> > Missing MODULE_DEVICE_TABLE for pci ids from benet driver found by clang.
>> > 
>> > Signed-off-by: Behan Webster <behanw@converseincode.com>
>> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> 
>> Why are you removing the device table?
>
> Behan took a patch that I did earlier and split it up to add descriptions.
> The patch is correct, but he either misunderstood or misexpressed the
> intention.
>
> This driver has two identical lines that both say 
>
> MODULE_DEVICE_TABLE(pci, be_dev_ids);
>
> I don't remember the exact symptom, but llvm/clang trips over this, while gcc
> silently ignores the second one.

GCC is probably being "helpful" and allowing multiple identical
definitions even though the C spec does not.  Obviously all but one
should go away.  No need to mention llvm, IMO.

-- 
Måns Rullgård
mans@mansr.com
