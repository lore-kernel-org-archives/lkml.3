Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3DKQTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:19:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36686 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3DKQTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:19:24 -0400
Message-ID: <5166E289.8070104@wwwdotorg.org>
Date: Thu, 11 Apr 2013 10:19:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Li Haifeng <omycle@gmail.com>
CC: pandaboard@googlegroups.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: Kexec couldn't reboot capture kernel on pandaboard ES with OMAP4460
References: <CAFNq8R5FFUyH+JgjoGc5ctgEfiLvxzi7fzawM7+wFX5nEyTv-w@mail.gmail.com> <51658B1A.6090706@wwwdotorg.org> <CAFNq8R6mRJRygfnYvZgwVWOqsrhrjNUYzyZGU0cVsnE30W_xGg@mail.gmail.com>
In-Reply-To: <CAFNq8R6mRJRygfnYvZgwVWOqsrhrjNUYzyZGU0cVsnE30W_xGg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 10:46 PM, Li Haifeng wrote:
> 2013/4/10 Stephen Warren <swarren@wwwdotorg.org>:
>> On 04/10/2013 03:35 AM, Li Haifeng wrote:
>>> Hi, everyone.
>>>
>>> Recently, I try to run kdump on pandaboard ES with omap4460. After
>>> load capture kernel by "kexec -l" and execute "kexec -e", the serial
>>> port output "Starting new kernel" and "Bye", then the system hangs up.
>>>
>>> I have tried the upstream Linux Kernel v3.4 and v3.8. All are with this issue.
>>
>> This is a shot in the dark. I assume you have SMP enabled. Can you use
>> hotplug to remove all CPUs other than CPU0, so that the kexec happens on
>> the boot CPU? That is certainly necessary for kexec to work correctly on
>> Tegra.
> 
> Thanks for your attention.
> 
> I do disable SMP feature. And the .config file for v3.8 could be found here:
> http://pastehtml.com/view/cylyrfejt.txt
...
> The output:
> [   57.373687] Starting new kernel
> [   57.377044] Bye!
> 
> Then system hangs.

Oh well, you've exhausted my knowledge I'm afraid! I can only suggesting
trying to enable earlyprintk and/or uncompressor debug in the kernel
you're kexec'ing and see if that yields any clue. Either that, or JTAG!
