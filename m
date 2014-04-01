Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaDAUl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:41:56 -0400
Received: from omr-d05.mx.aol.com ([205.188.109.202]:53400 "EHLO
	omr-d05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaDAUly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:41:54 -0400
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Subject: nf_conntrack: table full
X-MB-Message-Source: WebUI
X-MB-Message-Type: User
MIME-Version: 1.0
From: Pietro Paolini <pulsarpietro@aol.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL Webmail 38466-STANDARD
Message-Id: <8D11C01F3154466-1620-15304@webmail-vd015.sysops.aol.com>
X-Originating-IP: [92.109.158.175]
Date: Tue, 1 Apr 2014 16:41:53 -0400 (EDT)
x-aol-global-disposition: G
x-aol-sid: 3039ac1addd0533b24917777
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am doing some investigation regarding an error I am experiencing 
using my linux embedded device as router in my home network.

If I try to push the number the connections to around 20K I will se a 
lot of messages from the kernel saying :

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.                              

nf_conntrack: table full, dropping packet.

Actually this is fine for me since the number of allowed conntrack is 
/proc/sys/net/netfilter/nf_conntrack_max  is around 7844, the
strange thing is that the device will reboot after a while - actually 
my watchdog reboots the device since is not able to allocate memory -
I have a try with slabtop running and I have seen that  but monitoring 
the /proc/slabinfo:
3968 nf_conntrack_c0d4eacc
4392 size-8192
6360 skbuff_head_cache
15356 size-4096
31808 size-1024

Well size-1024 is quite high, do you know where is that from and how is 
that related to the packets coming in ? Even point me at the right
folder in the source code could be great since I am really lost here.

Thanks in advance,
Pietro.

"And therefore never send to know for whom the bell tolls"
pulsarpietro@aol.com
