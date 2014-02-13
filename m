Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaBMQhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:37:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45067 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaBMQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:37:09 -0500
Message-ID: <52FCF4B1.5030208@wwwdotorg.org>
Date: Thu, 13 Feb 2014 09:37:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2 4/6] ARM: firmware: add prepare_idle() operation
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com> <1391747706-1847-5-git-send-email-acourbot@nvidia.com> <52FCA5FC.80504@samsung.com>
In-Reply-To: <52FCA5FC.80504@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 04:01 AM, Tomasz Figa wrote:
> Hi Alexandre,
> 
> On 07.02.2014 05:35, Alexandre Courbot wrote:
>> Some firmwares do not put the CPU into idle mode themselves, but still
>> need to be informed that the CPU is about to enter idle mode before this
>> happens. Add a prepare_idle() operation to the firmware_ops structure to
>> handle such cases.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>   arch/arm/include/asm/firmware.h | 4 ++++
>>   1 file changed, 4 insertions(+)
> 
> I wonder if .do_idle() couldn't simply return an appropriate error code
> to let the upper layer know that it should proceed with normal CPU idle
> activation, while still letting the firmware know that the CPU is going
> to idle.

That seems to disagree with the naming of the operation, and the
semantics I assume it has, though. It seems clearer to add an explicit
separate op for this.

