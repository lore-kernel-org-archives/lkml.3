Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3KRUdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:08 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:37182 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011Ab3KRUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:03 -0500
Message-ID: <528A797B.6020807@hurleysoftware.com>
Date: Mon, 18 Nov 2013 15:32:59 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heorhi Valakhanovich <valahanovich@tut.by>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] tty: Only hangup once
References: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>	<20131117203850.46df2124@tormoz-pc> <20131118134211.17861db3@alan.etchedpixels.co.uk> <528A5043.6030901@hurleysoftware.com>
In-Reply-To: <528A5043.6030901@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 12:37 PM, Peter Hurley wrote:
> On 11/18/2013 08:42 AM, One Thousand Gnomes wrote:
>>> After upgrading to kernel 3.12 I noticed one issue with tmux software.
>>> The easiest way to reproduce will be:
>>> 1. Start tmux session as root.
>>> 2. Connect via ssh and use "tmux attach" to attach to the running
>>> session.
>>> 3. Kill ssh client.
>
> Heorhi,
>
> Thanks for the report.
>
>>> You can notice that shell (zsh in my case) and "tmux attach" are still
>>> remains in process' list. That didn't happen in previous kernels.

Heorhi,

I could not reproduce this behavior with zsh or bash.

In case I misunderstood, the steps I took to reproduce were,

[On ssh server machine running 3.12]
1.  Add 'set-option -g default-shell /usr/bin/zsh' to /etc/tmux.conf
2a. In terminal window, 'sudo tmux'
       - also tried -
2b. At root login on tty2, 'tmux'

Successfully starts tmux session. Then,

[On ssh client machine]
1. 'ssh user@server'
2. 'sudo tmux attach'
3. Switch to 2nd terminal window,
4. ps -ef | grep ssh
5. kill $pid_from_step4

This *did not* leave the 'tmux attach' process alive.

Is zsh your login shell as well? Maybe that's the required
component to reproduce the behavior you've observed.

Regards,
Peter Hurley




