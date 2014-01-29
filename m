Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaA2IMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:12:09 -0500
Received: from david.siemens.de ([192.35.17.14]:46555 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaA2ILx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:11:53 -0500
Message-ID: <52E8B7B0.8050803@siemens.com>
Date: Wed, 29 Jan 2014 09:11:28 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Plug racy xAPIC access of CPU hotplug code
References: <52E6AFFE.3030004@siemens.com> <20140127202252.GA11821@two.firstfloor.org> <52E767C2.2090807@siemens.com> <20140128115549.GA26230@gmail.com> <52E79DEA.3010408@siemens.com> <20140128211702.GB11821@two.firstfloor.org>
In-Reply-To: <20140128211702.GB11821@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-28 22:17, Andi Kleen wrote:
> Also with irq-off you of course still always have races against
> the NMI-level machine check.

The self-IPI triggered over NMI won't touch the high-part of the ICR and
will properly wait for ICR to become free again. So we are safe.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
