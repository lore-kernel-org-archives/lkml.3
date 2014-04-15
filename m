Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaDOPC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:02:58 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59013 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaDOPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:02:56 -0400
Message-ID: <534D4A1B.30002@gmail.com>
Date: Tue, 15 Apr 2014 11:02:51 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
References: <534D3762.4010905@manux.info>
In-Reply-To: <534D3762.4010905@manux.info>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-15 09:42, Emmanuel Colbus wrote:
> Now, back to the filesystem...
> 
> In order to associate devices to their files, the Linux kernel uses
> their major and minor numbers. However, mine doesn't; instead, I've
> attributed myself a single group of values (major=0, minor=0, for both
> character-mode and block-mode special files), with the meaning (for the
> userspace) "you cannot identify the content of this file based on its
> major and minor numbers".
> 
> As for my kernel, there is a syscall to associate such files with their
> proper peripherals (asper(2)), after which it internally identifies them
> using their inode and partition numbers; as for userspace, it has no
> choice but to use their names, as usual.
> 
> Do you have any objection to my taking of these values?
> 

According to Documentation/devices.txt:
	0		Unnamed devices (e.g. non-device mounts)
			0 = reserved as null device number

Based on this, I would say that you are probably better off using one of
the local use numbers (60-63 and 250-254 are reserved for local and
experimental use)

