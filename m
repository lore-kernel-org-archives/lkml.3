Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3HAOzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:55:23 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34243 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3HAOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:55:22 -0400
Message-ID: <51FA76D6.2060905@fastmail.fm>
Date: Thu, 01 Aug 2013 16:55:18 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Douglas Gilbert <dgilbert@interlog.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nick.cheng@areca.com.tw, stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com> <87ob9koogb.fsf@spindle.srvr.nix> <51F80294.50804@fastmail.fm> <877gg7n3rc.fsf@spindle.srvr.nix>
In-Reply-To: <877gg7n3rc.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:20 PM, Nix wrote:
> On 30 Jul 2013, Bernd Schubert told this:
>
>> On 07/30/2013 02:56 AM, Nix wrote:
>>> On 30 Jul 2013, Douglas Gilbert outgrape:
>>>
>>>> Please supply the information that Martin Petersen asked
>>>> for.
>>>
>>> Did it in private IRC (the advantage of working for the same division of
>>> the same company!)
>>>
>>> I didn't realise the original fix was actually implemented to allow
>>> Bernd, with a different Areca controller, to boot... obviously, in that
>>> situation, reversion is wrong, since that would just replace one won't-
>>> boot situation with another.
>>
>> Unless there is very simple fix the commit should reverted, imho. It
>> would better then to remove write-same support from the md-layer.
>
> I'm not using md on that machine, just LVM. Our suspicion is that ext4
> is doing a WRITE SAME for some reason.
>

I didn't check yet for other cases, mkfs.ext4 does WRITE SAME and with 
lazy init it also will happen after mounting the file system, while lazy 
init is running (inode zeroing).


Cheers,
Bernd
