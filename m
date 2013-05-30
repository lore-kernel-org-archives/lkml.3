Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab3E3Oin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:38:43 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:41558 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab3E3Oif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:38:35 -0400
Message-ID: <51A7646B.6080203@cogentembedded.com>
Date: Thu, 30 May 2013 18:38:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Timur Tabi <timur.tabi@calxeda.com>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>, tj@kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2] ata: increase retry count but shorten duration for
 Calxeda controller
References: <1369923509-3246-1-git-send-email-mark.langsdorf@calxeda.com> <51A76197.9080708@calxeda.com>
In-Reply-To: <51A76197.9080708@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 30-05-2013 18:26, Timur Tabi wrote:

>> -	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
>> +	const unsigned long timing[] = { 5, 100, 500};

> You'll save space and time if you also make this array "static",
> otherwise the compiler will build the array every time this function is
> called.

    No, *const* specifier is enough to not build this array every time. 
It will be put into the .const section.

WBR, Sergei

