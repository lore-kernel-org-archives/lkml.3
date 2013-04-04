Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764699Ab3DDU0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:26:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57404 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763121Ab3DDU0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:26:53 -0400
Message-ID: <515DE1C1.6080000@zytor.com>
Date: Thu, 04 Apr 2013 13:25:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 08/20] x86, ACPI: Find acpi tables in initrd early
 from head_32.S/head64.c
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org> <1362897887-30808-9-git-send-email-yinghai@kernel.org> <CAOJsxLG2Qg7vmLWirWK-GOBp65NxogGcAU5guoVphDu2G=BsjA@mail.gmail.com>
In-Reply-To: <CAOJsxLG2Qg7vmLWirWK-GOBp65NxogGcAU5guoVphDu2G=BsjA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 03:25 AM, Pekka Enberg wrote:
> 
> What is preventing us from making the 64-bit variant also work in flat
> mode to make the code consistent and not hiding the differences under
> the rug? What am I missing here?
> 

There is no such thing as "flat mode" in 64-bit mode.  We use a #PF
handler to emulate it, but we add the normal kernel offset when doing so.

In the 32-bit case the problem is that the kernel offset is not
available while in linear mode.  It *could* be created using segment
bases, but that would break Xen, I'm pretty sure, and possibly some
other too-clever environments.

	-hpa


