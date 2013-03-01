Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910Ab3CAHXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:23:34 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54738 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAHXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:23:33 -0500
Message-ID: <51305772.5050408@gmail.com>
Date: Fri, 01 Mar 2013 08:23:30 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: dmesg macro in Documentation/kdump/gdbmacros.txt outdated
References: <20130301013127.GA28038@blumentopf>
In-Reply-To: <20130301013127.GA28038@blumentopf>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.03.2013 02:31, Andreas Fenkart wrote:
> Is there an updated version matching the changed printk structure?

I hacked something up a while ago, but it's not perfect. The code below
stops dumping too early IIRC, but I never got around to fix that. Maybe
someone wants to look at it and help debug, so we can put it into
gdbmacros.txt ...

Thanks,
Daniel


define dmesg
        set $idx = 0
        set $seq = 0

        while ($seq++ < log_next_seq)
                set $buf = log_buf + $idx
                set $log = (struct log *) $buf

                if ($log->len == 0)
                        loop_break
                end

                printf "%s\n", (char *) ($buf + sizeof(struct log))
                set $idx += $log->len
        end
end

document dmesg
dmesg
Print the content of the kernel message buffer
end

