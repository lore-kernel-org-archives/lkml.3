Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3G2PB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:01:59 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:60349 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3G2PB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:01:58 -0400
From: Nix <nix@esperi.org.uk>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
Emacs: an inspiring example of form following function... to Hell.
Date: Mon, 29 Jul 2013 16:01:49 +0100
In-Reply-To: <51F67959.2060803@fastmail.fm> (Bernd Schubert's message of "Mon,
	29 Jul 2013 16:16:57 +0200")
Message-ID: <8738qxfm02.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Jul 2013, Bernd Schubert spake thusly:

> On 07/29/2013 03:05 PM, Nix wrote:
>> On 29 Jul 2013, Bernd Schubert said:
>>> I tested this patch with ARC-1260 and F/W V1.49, no issues. Also, this
>>> patch is only in 3.10.3, but not yet in 3.10.1.
>>
>> ... and I see this problem with 3.10.3 but not 3.10.1. (Haven't tried
>> 3.10.2.)
>
> Hmm, indeed that points to this commit. I just don't see what could fail there.
>
> Could you try to run these commands with 3.10.1?
>
> # # check if reporting opcodes works
> # sg_opcodes -v  -n /dev/sdX
>
> # check ata information page
> # sg_vpd --page=0x89 /dev/sdX

If this might cause the same problem I think I'd better wait until work
is done for the day and the machine is no longer loaded, and can be
rebooted without harm...

>> No changes to arcmsr between those versions... I suspect I'll have to
>> bisect, which will be a complete pig because every failure means a hard
>> powerdown of this box. Always-on servers rarely appreciate hard
>> powerdowns :(
>>
>
> Maybe just revert this commit? Helpful would be some scsi logging to
> see which command actually fails. I guess you don't have a serial
> console?

Not at that stage, no! And, yes, a test revert of this one commit will
be the first thing I try this evening / tomorrow morning (depending on
system load).

-- 
NULL && (void)
