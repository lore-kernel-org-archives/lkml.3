Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3AaI2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:28:23 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40259 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3AaI2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:28:20 -0500
Message-ID: <510A2B1C.1060108@suse.cz>
Date: Thu, 31 Jan 2013 09:28:12 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <5109A8F1.9040707@suse.cz> <5109B11C.2010400@suse.cz> <5170962.qHnbnlVDfx@vostro.rjw.lan> <20130131070926.GC4926@pd.tnic>
In-Reply-To: <20130131070926.GC4926@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 08:09 AM, Borislav Petkov wrote:
> On Thu, Jan 31, 2013 at 01:54:56AM +0100, Rafael J. Wysocki wrote:
>> On Thursday, January 31, 2013 12:47:40 AM Jiri Slaby wrote:
>>> On 01/31/2013 12:12 AM, Jiri Slaby wrote:
>>>> I think I will start with commenting parts of `power' script to see
>>>> exactly which of the power savings cause this.
>>>
>>> ... NMI watchdog. If I remove it from the script, the problem
>>> disappears. If I try it alone, I have those NMIs.
>>
>> Well, beats me. :-(
>>
>> I suspect that it doesn't quiesce itself sufficiently before image restoration
>> and we get some crosstalk between the boot kernel and the image kernel.
> 
> Well, I did what Jiri said causes it:
> 
> echo 0 > /proc/sys/kernel/nmi_watchdog
> 
> No NMI.
> 
> BUT(!), if I start powertop and set all tunables in the "Tunables" tab
> to "Good", then suspend to disk, when I resume I get the NMI and this
> time the unknown reason is 0x3c. Sounds like this needs bisection...

And, does it happen if you switch all of them but NMI wtd in there?

And if I pass nmi_watchdog=0 to the image kernel, it should be gone I guess.

-- 
js
suse labs
