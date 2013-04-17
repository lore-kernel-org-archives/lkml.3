Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286Ab3DQUAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:00:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58389 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965067Ab3DQUAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:00:20 -0400
Message-ID: <516EFF3D.4040506@zytor.com>
Date: Wed, 17 Apr 2013 12:59:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
References: <1366224198-49485-1-git-send-email-holt@sgi.com> <1366224198-49485-6-git-send-email-holt@sgi.com> <516EF9DE.6000707@zytor.com> <20130417194836.GK3658@sgi.com>
In-Reply-To: <20130417194836.GK3658@sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is also worth noting that the documentation says reboot=s[mp]#
whereas in fact only reboot=s# parse correctly.  I consider this to be a
bug.

If we centralized the parser, we could take a string like

"reboot=bios,smp32,warm"

and parse it into:

reboot_cpu = 32
reboot_mode = "bw"

... and pass the information in that form to the arch layer.  I don't
think we can do more parsing at that in the main kernel.

	-hpa

