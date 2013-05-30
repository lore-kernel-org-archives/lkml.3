Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3E3Oji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:39:38 -0400
Received: from smtp181.iad.emailsrvr.com ([207.97.245.181]:38487 "EHLO
	smtp181.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab3E3Ojc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:39:32 -0400
Message-ID: <51A764B4.9020302@calxeda.com>
Date: Thu, 30 May 2013 09:39:48 -0500
From: Timur Tabi <timur.tabi@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2] ata: increase retry count but shorten duration for
 Calxeda controller
References: <1369923509-3246-1-git-send-email-mark.langsdorf@calxeda.com> <51A76197.9080708@calxeda.com> <51A7646B.6080203@cogentembedded.com>
In-Reply-To: <51A7646B.6080203@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 09:38 AM, Sergei Shtylyov wrote:
>>> >> -	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
>>> >> +	const unsigned long timing[] = { 5, 100, 500};
>> > You'll save space and time if you also make this array "static",
>> > otherwise the compiler will build the array every time this function is
>> > called.
>     No, *const* specifier is enough to not build this array every time. 
> It will be put into the .const section.

Ok.  Now that I think about it, that makes sense.

-- 
Timur Tabi
Software Developer at Calxeda
