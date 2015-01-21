Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbbAUJBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:01:42 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51391 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAUJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:01:35 -0500
Message-ID: <54BF6AEC.5090706@gmail.com>
Date: Wed, 21 Jan 2015 10:01:32 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Jeremy Newton <alexjnewt@hotmail.com>, Thomas Koch <linrunner@gmx.net>,
        =?windows-1252?Q?Andr=E9_Erdmann?= <dywi@mailerd.de>,
        =?windows-1252?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Uhhuh - Dazed and confused, but trying to continue  :)
References: <54BB8FFE.5010308@gmail.com> <20150119134942.GH116159@redhat.com>
In-Reply-To: <20150119134942.GH116159@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2015 14:49, Don Zickus wrote:
> On Sun, Jan 18, 2015 at 11:50:38AM +0100, poma wrote:
>>
>> Salutem
>>
>> This happened only on thaw from S4 aka hibernate.
>> What should be "strange power saving mode" these messages relate!?
>>
>> [  208.252986] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>> [  208.252991] Do you have a strange power saving mode enabled?
>> [  208.252992] Dazed and confused, but trying to continue
>>
>> 3.18.3-200.fc21.x86_64
> 
> This looks to be an external unknown NMI (unless you can reproduce on
> something other than cpu0).
> 
> I would have to know what hardware you have and see the dmesg log after
> the resume from hibernate.
> 
> You can open a bz and assign it to me.
> 
> Just attach the dmesg log, lspci and lspci -t output to the bz.
> 
> Though this is most likely a pci device firmware problem.  But I can try
> to narrow it down.
> 
> Cheers,
> Don
> 

Thank you, in the meantime, I've found what causes non-maskable interrupt, [23]d on CPU 0, on resuming S4,
on AMD Phenom(tm) II X4 955 Processor.

/etc/default/tlp
...
# Kernel NMI Watchdog
# 0=disable (default, saves power) / 1=enable (for kernel debugging only)
NMI_WATCHDOG=0

Toggling to 1, messages no longer appear,
NMI_WATCHDOG=1

$ cat /proc/sys/kernel/nmi_watchdog
1
$ sysctl kernel.watchdog
kernel.watchdog = 1

Isn't it brilliant.


