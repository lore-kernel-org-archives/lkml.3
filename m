Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706AbaDBWae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:30:34 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41685 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030634AbaDBWa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:30:29 -0400
Date: Wed, 2 Apr 2014 23:30:24 +0100
From: Struan Bartlett <struan.bartlett@gmail.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        netdev@vger.kernel.org, davem@davemloft.net, nikolay@redhat.com,
        andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        jiri@resnulli.us, joe@perches.com, alonid@postram.com
Subject: Re: [PATCH v2] netconsole: Add tty driver
Message-ID: <20140402223024.GA12627@NewsNow.co.uk>
References: <533B2F03.6060008@gmail.com>
 <201404022116.HIB82683.FOJMFFHVStOLOQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404022116.HIB82683.FOJMFFHVStOLOQ@I-love.SAKURA.ne.jp>
FCC: imap://struan.bartlett%40gmail.com@imap.googlemail.com/[Gmail]/Sent Mail
X-Identity-Key: id4
X-Account-Key: account4
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0)
 Gecko/20100101 Thunderbird/24.3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 14:16, Tetsuo Handa wrote:
> Struan Bartlett wrote:
>> Adds tty driver to netconsole module. When module is loaded,
>> creates /dev/netcon0 device and enables support for console=netcon0
>> kernel cmdline option, causing /dev/console output to be sent to
>> /dev/netcon0. This allows startup/shutdown script output from
>> headless platforms to be logged over (secure) network.
> 
> Excuse me, but I think that the netconsole logging can work only during network
> interfaces (e.g. eth0) are up. Did this patch description assume that the
> network interfaces are up before the startup script is started and the shutdown
> script is finished before the network interfaces are down?

Yes it did. I hope I have clarified that in the v3 patch description.
In practice, at least in a Debian environment: i) the netconsole module itself
is generally capable of raising the network interface when it is loaded by the
initramfs init script (which precedes all /etc/init.d/* scripts); ii) very
little of consequence tends to happens during shutdown after networking is
stopped; iii) equally, it is not usually problematic to disable the networking
shutdown script, since it runs on platforms about to be rebooted or powered off.
We do this by editing the Default-Stop LSB header in /etc/init.d/networking.

> By the way, I uploaded a logger specialized for receiving netconsole messages
> to http://sourceforge.jp/projects/akari/scm/svn/tree/head/branches/udplogger/ .

Thank you. I'll check it out.
