Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3LLUhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:37:06 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:40015 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3LLUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:36:59 -0500
Message-ID: <52AA1E67.6000801@linux.com>
Date: Thu, 12 Dec 2013 21:36:55 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Robin H. Johnson" <robbat2@gentoo.org>, Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: provide the ability to disable a disk via the
 params.
References: <1386464187-6993-1-git-send-email-robbat2@gentoo.org> <20131212133935.GA32683@htj.dyndns.org> <robbat2-20131212T200207-028507804Z@orbis-terrarum.net>
In-Reply-To: <robbat2-20131212T200207-028507804Z@orbis-terrarum.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Robin.

2013-12-12 21:22, Robin H. Johnson:
> On Thu, Dec 12, 2013 at 08:39:35AM -0500, Tejun Heo wrote:
>> Hello, Robin.
>>
>> On Sat, Dec 07, 2013 at 04:56:27PM -0800, Robin H. Johnson wrote:
>>> +		{ "disable",	.horkage_on	= ATA_HORKAGE_DISABLE },
>>> +		{ "nodisable",	.horkage_off	= ATA_HORKAGE_DISABLE },
>> Given the current usage of ATA_HORKAGE_DISABLE, I don't think we need
>> "nodisable".  Let's just add "disable" for now.  Can you please update
>> the patch and resend?
> Before I do so, I have two questions:
> 1.
> Countering your nodisable comment, would it be valid to do:
> libata.force=2:disable libata.force=2.02:nodisable
> To disable all of port 2 except device 2?

I think that makes sense and I support having 'nodisable'.
>
> 2. One of my friends wondered if it would be worthwhile to add force
> keywords for other HORKAGE bits, and if so, should the
> ata_lflag/ata_link force bits also be presented?

I don't think so. Most of the other HORKAGEs are automatically
recognized and applied by the code. I think the only ones
which can cause trouble if not detected at first are the ones that are
currently in the list.

-- 
Regards,
Levente Kurusa
