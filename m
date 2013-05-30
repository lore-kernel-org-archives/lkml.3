Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3E3Ogs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:36:48 -0400
Received: from smtp181.iad.emailsrvr.com ([207.97.245.181]:45151 "EHLO
	smtp181.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3E3Ogj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:36:39 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2013 10:36:39 EDT
Message-ID: <51A76197.9080708@calxeda.com>
Date: Thu, 30 May 2013 09:26:31 -0500
From: Timur Tabi <timur.tabi@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: tj@kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2] ata: increase retry count but shorten duration for
 Calxeda controller
References: <1369923509-3246-1-git-send-email-mark.langsdorf@calxeda.com>
In-Reply-To: <1369923509-3246-1-git-send-email-mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 09:18 AM, Mark Langsdorf wrote:
> -	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +	const unsigned long timing[] = { 5, 100, 500};

You'll save space and time if you also make this array "static",
otherwise the compiler will build the array every time this function is
called.

-- 
Timur Tabi
Software Developer at Calxeda
